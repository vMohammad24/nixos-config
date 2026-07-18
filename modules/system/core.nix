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
      extra-substituters = ["https://hyprland.cachix.org" "https://framr.cachix.org" "https://vicinae.cachix.org" "https://nix-amd-ai.cachix.org" "https://attic.xuyh0120.win/lantian"];
      extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "framr.cachix.org-1:Nn6BXpOrE0I1sO89xW8l2WVcf2FD4UqU6PD30sgRLZk=" "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
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
