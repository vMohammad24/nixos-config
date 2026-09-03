{
  description = "NixOS configurations for main-desktop and server";

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
    moonshine = {
      url = "github:hgaiser/moonshine";
      inputs.nixpkgs.follows = "nixpkgs";
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
    hagezi-pro = {
      url = "file+https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
      flake = false;
    };
    hagezi-tif = {
      url = "file+https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt";
      flake = false;
    };
    hagezi-whitelist-referral = {
      url = "file+https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/whitelist-referral.txt";
      flake = false;
    };
    windows-spy-blocker-hosts = {
      url = "file+https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt";
      flake = false;
    };
    speedtest-exporter = {
      url = "github:heathcliff26/speedtest-exporter/v1.6.3";
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
    rffmpeg = {
      url = "github:joshuaboniface/rffmpeg";
      flake = false;
    };
    jellyfin-desktop = {
      url = "github:xaltsc/jellyfin-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-parts.follows = "flake-parts";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/pull/16013/merge";
      inputs.pre-commit-hooks.follows = "";
    };
    niri = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    checks.x86_64-linux.monitoring-configs = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      alertmanagerConfig = pkgs.writeText "alertmanager-unchecked.json" (
        builtins.toJSON self.nixosConfigurations.server.config.services.prometheus.alertmanager.configuration
      );
    in
      pkgs.runCommand "monitoring-configs-check" {
        nativeBuildInputs = [
          pkgs.grafana-alloy
          pkgs.grafana-loki
          pkgs.envsubst
          pkgs.jq
          pkgs.prometheus-alertmanager
          pkgs.prometheus.cli
        ];
      } ''
        promtool check rules ${./hosts/server/selfhost/alerts.yml}
        lokitool rules lint --dry-run ${./hosts/server/selfhost/loki-rules/fake/server.yml}
        alloy fmt --test ${./hosts/server/selfhost/loki.alloy}
        alloy validate ${./hosts/server/selfhost/loki.alloy}
        export DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/0/placeholder
        envsubst -i ${alertmanagerConfig} -o alertmanager.yml
        amtool check-config alertmanager.yml
        jq empty \
          ${./hosts/server/selfhost/dashboards/infrastructure.json} \
          ${./hosts/server/selfhost/dashboards/server-logs.json} \
          ${./hosts/server/selfhost/dashboards/server-overview.json} \
          ${./hosts/server/selfhost/dashboards/speedtest.json} \
          ${./hosts/server/selfhost/dashboards/tidal-subsonic.json} \
          ${./hosts/server/selfhost/dashboards/unbound.json}

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
        inputs.niri.nixosModules.niri-nix
        ./modules/desktops/niri.nix
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
