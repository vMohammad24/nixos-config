{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "0.0.0.0" = ["paradise-s1.battleye.com" "test-s1.battleye.com" "paradiseenhanced-s1.battleye.com"];
  };

  time.timeZone = "Asia/Amman";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
