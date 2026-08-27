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
  nixpkgs.config.rocmSupport = isDesktop;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    resolution = lib.mkIf isDesktop "2560x1440";
    maxGenerations = 10;
  };

  boot.kernelPackages =
    if isDesktop
    then pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3
    else pkgs.cachyosKernels.linuxPackages-cachyos-server;

  networking = {
    networkmanager.enable = false;
    useNetworkd = isDesktop;

    hosts = lib.mkIf isDesktop {
      "0.0.0.0" = [
        "paradise-s1.battleye.com"
        "test-s1.battleye.com"
        "paradiseenhanced-s1.battleye.com"
      ];
    };

    nftables.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = lib.optionals isDesktop ["virbr0"];
    };
  };

  systemd.network.networks."10-enp5s0" = lib.mkIf isDesktop {
    matchConfig.Name = "enp5s0";

    dns = [
      "192.168.1.31"
    ];

    domains = [
      "~lan.vmohammad.dev"
    ];

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };

    dhcpV4Config.UseDNS = false;
    dhcpV6Config.UseDNS = false;
    ipv6AcceptRAConfig.UseDNS = false;
  };

  time.timeZone = "Asia/Amman";

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = lib.optionals isDesktop ["vmohammad"];
      extra-substituters =
        ["https://attic.xuyh0120.win/lantian"]
        ++ lib.optionals isDesktop [
          "https://hyprland.cachix.org"
          "https://framr.cachix.org"
          "https://vicinae.cachix.org"
          "https://nix-amd-ai.cachix.org"
          "https://niri-nix.cachix.org"
        ];
      extra-trusted-public-keys =
        ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="]
        ++ lib.optionals isDesktop [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "framr.cachix.org-1:Nn6BXpOrE0I1sO89xW8l2WVcf2FD4UqU6PD30sgRLZk="
          "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
          "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ="
          "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        ];
    };
    extraOptions = lib.optionalString isDesktop ''
      !include /run/agenix/nix_conf
    '';
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
