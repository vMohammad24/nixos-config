{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.rffmpeg;
  isController = cfg.role == "controller";
  isWorker = cfg.role == "worker";
  jellyfinStateDir = "/mnt/HDD/.state/nixarr/jellyfin";
  jellyfinDataDir = "${jellyfinStateDir}/data";
  jellyfinCacheDir = "${jellyfinStateDir}/cache";
  mediaDir = "/mnt/HDD/media";
  vaapiDevice = "/dev/dri/jellyfin-vaapi";
  rffmpegStateDir = "/var/lib/rffmpeg";
  rffmpegKeyDir = "/var/lib/rffmpeg-ssh";
  ffmpeg = pkgs.jellyfin-ffmpeg;
  rffmpegPython = pkgs.python3.withPackages (pythonPackages: [
    pythonPackages.click
    pythonPackages.pyyaml
  ]);
  rffmpeg = pkgs.stdenvNoCC.mkDerivation {
    pname = "jellyfin-remote-transcoder";
    version = inputs.rffmpeg.shortRev or "unstable";
    src = inputs.rffmpeg;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 rffmpeg "$out/bin/rffmpeg"
      substituteInPlace "$out/bin/rffmpeg" \
        --replace-fail '#!/usr/bin/env python3' '#!${rffmpegPython}/bin/python3' \
        --replace-fail 'ssh-%r@%h:%p' 'ssh-%i-%r@%h:%p'
      ln -s rffmpeg "$out/bin/ffmpeg"
      ln -s rffmpeg "$out/bin/ffprobe"

      runHook postInstall
    '';

    meta = {
      description = "Remote SSH FFmpeg wrapper";
      homepage = "https://github.com/joshuaboniface/rffmpeg";
      license = lib.licenses.gpl3Plus;
      mainProgram = "rffmpeg";
      platforms = lib.platforms.linux;
    };
  };
  hardwareAwareFfmpeg = pkgs.symlinkJoin {
    name = "jellyfin-hardware-aware-ffmpeg-${ffmpeg.version}";
    paths = [
      (pkgs.writeShellApplication {
        name = "ffmpeg";
        runtimeInputs = [pkgs.coreutils];
        text = ''
          arguments=("$@")
          renderNode="$(readlink -f ${vaapiDevice})"
          vendorFile="/sys/class/drm/''${renderNode##*/}/device/vendor"

          if [[ -r "$vendorFile" ]] && [[ "$(< "$vendorFile")" == "0x1002" ]]; then
            arguments=()
            for argument in "$@"; do
              arguments+=("''${argument//,driver=iHD/,driver=radeonsi}")
            done
          fi

          exec ${ffmpeg}/bin/ffmpeg "''${arguments[@]}"
        '';
      })
      (pkgs.writeShellApplication {
        name = "ffprobe";
        text = ''
          exec ${ffmpeg}/bin/ffprobe "$@"
        '';
      })
    ];
  };
  jellyfinWithRffmpeg = pkgs.jellyfin.override {
    jellyfin-ffmpeg = rffmpeg;
  };
  initializeRffmpeg = pkgs.writeShellApplication {
    name = "initialize-rffmpeg";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.openssh
      rffmpeg
    ];
    text = ''
      install -d -m 0750 -o jellyfin -g media ${rffmpegKeyDir}
      install -d -m 0700 -o jellyfin -g media ${jellyfinDataDir}/.ssh

      if [ ! -s ${rffmpegKeyDir}/id_ed25519 ]; then
        ssh-keygen -q -t ed25519 -N "" -C "jellyfin@server-rffmpeg" \
          -f ${rffmpegKeyDir}/id_ed25519
      fi

      chmod 0600 ${rffmpegKeyDir}/id_ed25519
      chmod 0644 ${rffmpegKeyDir}/id_ed25519.pub

      install -m 0600 -o jellyfin -g media \
        ${rffmpegKeyDir}/id_ed25519.pub \
        ${jellyfinDataDir}/.ssh/authorized_keys

      if [ ! -s ${rffmpegStateDir}/rffmpeg.db ]; then
        rffmpeg init --no-root --yes
        rffmpeg add --name main-desktop ${cfg.workerAddress}
      elif ! rffmpeg status | grep -Fq ${cfg.workerAddress}; then
        rffmpeg add --name main-desktop-${cfg.workerAddress} ${cfg.workerAddress}
      fi

      chmod 0660 ${rffmpegStateDir}/rffmpeg.db

      if ! ssh \
        -q \
        -o BatchMode=yes \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ${rffmpegKeyDir}/id_ed25519 \
        jellyfin@${cfg.workerAddress} \
        ${hardwareAwareFfmpeg}/bin/ffmpeg -version; then
        echo "WARNING: rffmpeg worker ${cfg.workerAddress} is not ready; local VAAPI fallback will be used" >&2
      fi

      ${rffmpeg}/bin/ffmpeg -version
    '';
  };
in {
  options.myConfig.rffmpeg = {
    enable = lib.mkEnableOption "remote Jellyfin FFmpeg processing";

    role = lib.mkOption {
      type = lib.types.enum ["controller" "worker"];
      default = "controller";
      description = "Whether this host runs Jellyfin or executes its FFmpeg jobs.";
    };

    controllerAddress = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.31";
      description = "LAN address of the Jellyfin/rffmpeg controller.";
    };

    workerAddress = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.30";
      description = "LAN address of the rffmpeg worker.";
    };

    interface = lib.mkOption {
      type = lib.types.str;
      description = "LAN interface used for the private rffmpeg connection.";
    };

    vaapiVendorId = lib.mkOption {
      type = lib.types.str;
      description = "PCI vendor ID whose render node is exposed to Jellyfin as the common VAAPI device.";
    };

    vaapiRenderDevice = lib.mkOption {
      type = lib.types.str;
      description = "Stable by-path render device exposed at the common Jellyfin VAAPI path.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = !isController || config.services.jellyfin.enable;
          message = "The rffmpeg controller role requires services.jellyfin.enable.";
        }
      ];

      services.udev.extraRules = ''
        SUBSYSTEM=="drm", KERNEL=="renderD*", ATTRS{vendor}=="${cfg.vaapiVendorId}", SYMLINK+="dri/jellyfin-vaapi"
      '';

      systemd.services.rffmpeg-vaapi-device = {
        description = "Create the common rffmpeg VAAPI device path";
        wantedBy = ["multi-user.target"];
        before = lib.optionals isController ["jellyfin.service"];
        after = ["systemd-udev-settle.service"];
        wants = ["systemd-udev-settle.service"];
        serviceConfig.Type = "oneshot";
        script = ''
          if [ ! -e ${cfg.vaapiRenderDevice} ]; then
            echo "VAAPI render device ${cfg.vaapiRenderDevice} does not exist" >&2
            exit 1
          fi
          ln -sfn ${cfg.vaapiRenderDevice} ${vaapiDevice}
        '';
      };

      environment.systemPackages =
        [
          pkgs.libva-utils
          hardwareAwareFfmpeg
        ]
        ++ lib.optionals isController [rffmpeg]
        ++ lib.optionals isWorker [ffmpeg];
    }

    (lib.mkIf isController {
      hardware.graphics = {
        enable = true;
        extraPackages = [pkgs.intel-media-driver];
      };

      services.jellyfin = {
        package = lib.mkForce jellyfinWithRffmpeg;
        forceEncodingConfig = true;
        hardwareAcceleration = {
          enable = true;
          type = "vaapi";
          device = vaapiDevice;
        };
        transcoding = {
          enableHardwareEncoding = true;
          hardwareDecodingCodecs = {
            h264 = true;
            hevc = true;
            hevc10bit = true;
            mpeg2 = true;
            vp9 = true;
          };
          hardwareEncodingCodecs.hevc = true;
        };
      };

      environment.etc."rffmpeg/rffmpeg.yml".text = ''
        rffmpeg:
          logging:
            log_to_file: true
            logfile: "/var/log/rffmpeg/rffmpeg.log"
            debug: false
          directories:
            state: "${rffmpegStateDir}"
            persist: "/run/rffmpeg"
            owner: jellyfin
            group: media
          remote:
            user: jellyfin
            persist: 300
            args:
              - "-i"
              - "${rffmpegKeyDir}/id_ed25519"
              - "-o"
              - "BatchMode=yes"
          commands:
            ssh: "${pkgs.openssh}/bin/ssh"
            ffmpeg: "${hardwareAwareFfmpeg}/bin/ffmpeg"
            ffprobe: "${hardwareAwareFfmpeg}/bin/ffprobe"
            fallback_ffmpeg: "${hardwareAwareFfmpeg}/bin/ffmpeg"
            fallback_ffprobe: "${hardwareAwareFfmpeg}/bin/ffprobe"
      '';

      services.nfs.server = {
        enable = true;
        hostName = cfg.controllerAddress;
        exports = {
          "${mediaDir}" = {
            "${cfg.workerAddress}/32" = [
              "rw"
              "sync"
              "no_subtree_check"
              "no_root_squash"
            ];
          };
          "${jellyfinStateDir}" = {
            "${cfg.workerAddress}/32" = [
              "rw"
              "sync"
              "no_subtree_check"
              "no_root_squash"
            ];
          };
        };
      };
      services.nfs.settings.nfsd = {
        vers3 = "n";
        vers4 = "y";
      };

      networking.firewall.interfaces.${cfg.interface}.allowedTCPPorts = [2049];

      systemd.tmpfiles.rules = [
        "d ${rffmpegStateDir} 0770 jellyfin media - -"
        "d ${rffmpegKeyDir} 0750 jellyfin media - -"
        "z ${rffmpegStateDir}/rffmpeg.db 0660 jellyfin media - -"
        "z ${rffmpegKeyDir}/id_ed25519 0600 jellyfin media - -"
        "z ${rffmpegKeyDir}/id_ed25519.pub 0644 jellyfin media - -"
        "d /run/rffmpeg 2770 jellyfin media - -"
        "d /var/log/rffmpeg 2770 jellyfin media - -"
        "f /var/log/rffmpeg/rffmpeg.log 0660 jellyfin media - -"
        "z /var/log/rffmpeg/rffmpeg.log 0660 jellyfin media - -"
        "d ${jellyfinCacheDir}/temp 0700 jellyfin media - -"
      ];

      users.users.vmohammad.extraGroups = ["media"];

      systemd.services = {
        rffmpeg-initialize = {
          description = "Initialize rffmpeg and its Jellyfin SSH identity";
          before = ["jellyfin.service"];
          after = ["nfs-server.service"];
          wants = ["nfs-server.service"];
          requiredBy = ["jellyfin.service"];
          unitConfig.RequiresMountsFor = [jellyfinDataDir];
          serviceConfig = {
            Type = "oneshot";
            User = "jellyfin";
            Group = "media";
            ExecStart = lib.getExe initializeRffmpeg;
          };
          environment.RFFMPEG_CONFIG = "/etc/rffmpeg/rffmpeg.yml";
        };

        jellyfin = {
          after = ["rffmpeg-vaapi-device.service"];
          requires = ["rffmpeg-vaapi-device.service"];
          path = [rffmpeg];
          environment = {
            RFFMPEG_CONFIG = "/etc/rffmpeg/rffmpeg.yml";
            TMPDIR = "${jellyfinCacheDir}/temp";
          };
          serviceConfig.DeviceAllow = lib.mkForce ["${vaapiDevice} rw"];
        };
      };
    })

    (lib.mkIf isWorker {
      hardware.graphics.enable = true;

      users = {
        groups.media.gid = 169;
        users.jellyfin = {
          isSystemUser = true;
          uid = 146;
          group = "media";
          home = jellyfinDataDir;
          shell = pkgs.bashInteractive;
          extraGroups = [
            "render"
            "video"
          ];
        };
      };

      fileSystems = {
        ${mediaDir} = {
          device = "${cfg.controllerAddress}:${mediaDir}";
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "_netdev"
            "nofail"
            "x-systemd.automount"
            "x-systemd.idle-timeout=10min"
            "sync"
            "actimeo=1"
          ];
        };
        ${jellyfinStateDir} = {
          device = "${cfg.controllerAddress}:${jellyfinStateDir}";
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "_netdev"
            "nofail"
            "x-systemd.automount"
            "x-systemd.idle-timeout=10min"
            "sync"
            "actimeo=1"
          ];
        };
      };

      networking.firewall.interfaces.${cfg.interface}.allowedTCPPorts = [22];

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      systemd.tmpfiles.rules = [
        "d /mnt/HDD 0755 root root - -"
        "d /mnt/HDD/.state 0755 root root - -"
        "d /mnt/HDD/.state/nixarr 0755 root root - -"
        "d ${mediaDir} 0755 root root - -"
        "d ${jellyfinStateDir} 0755 root root - -"
      ];
    })
  ]);
}
