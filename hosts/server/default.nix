{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./backups.nix
    ./secrets.nix
    ./selfhost
    ./nvidia-block.nix
  ];

  networking.hostName = "server";

  services.timesyncd.servers = ["162.159.200.1" "162.159.200.123"];

  systemd.services = {
    cloudflared-tunnel-3d9a81e9-9dab-43a5-b910-2240006a90dc.startLimitIntervalSec = 0;
    cloudflared-tunnel-b6180c38-8f39-4f1a-a115-ca4e29e9ca04.startLimitIntervalSec = 0;
    searx = {
      startLimitIntervalSec = 0;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 15;
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.accept_ra" = 2;
    "net.ipv6.conf.default.accept_ra" = 2;
    "net.ipv6.conf.eno2.accept_ra" = 2;
  };

  nix.settings.trusted-users = ["vmohammad"];

  myConfig.ai.enable = false;
  myConfig.backups.enable = true;
  myConfig.monitoring.enable = true;
  myConfig.rr.enable = true;
  myConfig.forgejo-runner.enable = false;
  myConfig.honcho.enable = true;
  myConfig.gpu.enable = false;
  myConfig.rffmpeg = {
    enable = true;
    role = "controller";
    interface = "eno2";
    vaapiVendorId = "0x8086";
  };
  virtualisation.docker.enable = config.myConfig.forgejo-runner.enable;

  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  boot.kernelParams = [
    "intel_pstate=no_turbo"
    "video=eDP-1:d"
    "consoleblank=60"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="cpu", ACTION=="add", ATTR{cpufreq/energy_performance_preference}="power"
  '';

  systemd.services.rfkill-block-wifi = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill block wifi";
    };
  };

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowSuspendThenHibernate = false;
    AllowHybridSleep = false;
  };

  security.sudo.extraRules = [
    {
      users = ["vmohammad"];
      commands = [
        {
          command = "/run/current-system/sw/bin/nix build --no-link --profile /nix/var/nix/profiles/system *";
          options = ["NOPASSWD"];
        }
        {
          command = "^/nix/store/[a-z0-9]{32}-nixos-system-server-[^/]+/bin/switch-to-configuration$ ^(switch|boot|test)$";
          options = ["NOPASSWD" "SETENV"];
        }
      ];
    }
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  users.users.vmohammad.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXYZZHOoZbjw3SWHxdJh2FAc7yEnusqmjcScpF0gjDW hermes@main-desktop"
  ];

  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-uuid/a8a13d43-ce2d-43a6-b50d-34a1084722f4";
    fsType = "xfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "x-gvfs-show"
    ];
  };

  systemd.tmpfiles.rules = ["d /mnt/HDD 0755 root root - -"];
}
