{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  isDesktop = config.myConfig.isDesktop;
in {
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    resolution = "2560x1440";
    maxGenerations = 10;
    extraEntries = ''
      /ShittyOS
        protocol: efi
        path: guid(0aaef0fc-c912-430b-a081-e3578f5c8ff8):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  boot.kernelPackages =
    if isDesktop
    then pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3
    else pkgs.cachyosKernels.linuxPackages-cachyos-server;

  networking.networkmanager.enable = true;
  networking.hosts = lib.mkIf isDesktop {
    "0.0.0.0" = [
      "paradise-s1.battleye.com"
      "test-s1.battleye.com"
      "paradiseenhanced-s1.battleye.com"
    ];
  };
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [25565 3000 53];
    allowedUDPPorts = [25565 53];
  };

  time.timeZone = "Asia/Amman";

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  security.polkit.enable = true;

  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192;
    virtualisation.cores = 6;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  system.stateVersion = "25.11";
}
