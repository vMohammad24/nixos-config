{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = ["ntfs3"];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "0.0.0.0" = ["paradise-s1.battleye.com" "test-s1.battleye.com" "paradiseenhanced-s1.battleye.com"];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 3000 ];
    allowedUDPPorts = [ 25565 ];
  };

  time.timeZone = "Asia/Amman";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.stateVersion = "25.11";
}
