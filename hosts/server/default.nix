{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./selfhost
    ./nvidia-block.nix
  ];

  networking.hostName = "server";

  myConfig.ai.enable = false;
  myConfig.rr.enable = false;
  myConfig.forgejo-runner.enable = false;
  virtualisation.docker.enable = config.myConfig.forgejo-runner.enable;

  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  boot.kernelParams = ["intel_pstate=no_turbo"];

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

  security.sudo.wheelNeedsPassword = false;

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
