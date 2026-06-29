{config, ...}: {
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
