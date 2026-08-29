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

  nix.settings.trusted-users = ["vmohammad"];

  myConfig.ai.enable = false;
  myConfig.backups.enable = true;
  myConfig.monitoring.enable = true;
  myConfig.rr.enable = true;
  myConfig.forgejo-runner.enable = false;
  myConfig.gpu.enable = true;
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
