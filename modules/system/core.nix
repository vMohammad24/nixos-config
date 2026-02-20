{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Amman";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
