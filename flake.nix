{
  description = "Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wl-mouse = {
      url = "git+https://heliopolis.live/vmohammad/wl-mouse.git?ref=feat/updates";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    tss = {
      url = "github:vMohammad24/TidalSubSonic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
      inputs.darwin.follows = "";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    hagezi = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };
    windows-spy-blocker = {
      url = "github:crazy-max/WindowsSpyBlocker";
      flake = false;
    };
    framr = {
      url = "github:vMohammad24/framr";
      inputs.flake-utils.follows = "flake-utils";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.systems.follows = "systems";
    };
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jellyfin-desktop = {
      url = "github:xaltsc/jellyfin-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-parts.follows = "flake-parts";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.pre-commit-hooks.follows = "";
    };
  };

  nixConfig = {
    extra-substituters = ["https://hyprland.cachix.org" "https://framr.cachix.org" "https://vicinae.cachix.org" "https://nix-amd-ai.cachix.org" "https://attic.xuyh0120.win/lantian"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "framr.cachix.org-1:Nn6BXpOrE0I1sO89xW8l2WVcf2FD4UqU6PD30sgRLZk=" "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    checks.x86_64-linux.monitoring-configs = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.runCommand "monitoring-configs-check" {
        nativeBuildInputs = [
          pkgs.grafana-alloy
          pkgs.grafana-loki
          pkgs.jq
          pkgs.prometheus.cli
        ];
      } ''
        promtool check rules ${./hosts/server/selfhost/alerts.yml}
        lokitool rules lint --dry-run ${./hosts/server/selfhost/loki-rules/fake/server.yml}
        alloy fmt --test ${./hosts/server/selfhost/loki.alloy}
        alloy validate ${./hosts/server/selfhost/loki.alloy}
        jq empty \
          ${./hosts/server/selfhost/dashboards/infrastructure.json} \
          ${./hosts/server/selfhost/dashboards/server-logs.json} \
          ${./hosts/server/selfhost/dashboards/server-overview.json}

        grep -F 'transport="kernel"' ${./hosts/server/selfhost/loki-rules/fake/server.yml}
        grep -F '| __error__=""' ${./hosts/server/selfhost/loki-rules/fake/server.yml}
        touch $out
      '';

    formatter.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.writeShellScriptBin "alejandra" ''
        exec ${pkgs.alejandra}/bin/alejandra "''${@:-.}"
      '';
    nixosConfigurations.main-desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/main-desktop/default.nix
        ./modules/system
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.vmohammad = ./users/vmohammad/default.nix;
            backupFileExtension = "backup";
          };
        }
        inputs.agenix.nixosModules.default
        inputs.vicinae.nixosModules.default
        ./modules/stylix.nix
        {
          nixpkgs.config.allowUnfree = true;
        }
        inputs.hyprland.nixosModules.default
        ./modules/desktops/hyprland.nix
        ./modules/desktops/mango.nix
      ];
    };
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/server/default.nix
        ./modules/system
        ./modules/stylix.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.vmohammad = ./users/vmohammad/default.nix;
            backupFileExtension = "backup";
          };
        }
        inputs.agenix.nixosModules.default
        {
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };
}
