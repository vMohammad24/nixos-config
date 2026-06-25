{
  description = "Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wl-mouse = {
      url = "git+https://heliopolis.live/creations/wl-mouse.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tss = {
      url = "github:vMohammad24/TidalSubSonic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";

    framr.url = "github:vMohammad24/framr";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = ["https://framr.cachix.org" "https://vicinae.cachix.org" "https://nix-amd-ai.cachix.org" "https://attic.xuyh0120.win/lantian"];
    extra-trusted-public-keys = ["framr.cachix.org-1:Nn6BXpOrE0I1sO89xW8l2WVcf2FD4UqU6PD30sgRLZk=" "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    formatter.x86_64-linux = inputs.alejandra.packages.x86_64-linux.default;
    nixosConfigurations.main-desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/main-desktop/default.nix
        ./modules/system
        home-manager.nixosModules.home-manager
        inputs.nix-amd-ai.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.vmohammad = ./users/vmohammad/default.nix;
            backupFileExtension = "backup";
          };
        }
        inputs.stylix.nixosModules.stylix
        inputs.agenix.nixosModules.default
        inputs.vicinae.nixosModules.default
        inputs.mangowm.nixosModules.mango
        ./modules/stylix.nix
        {
          nixpkgs.config.allowUnfree = true;
        }
        ./modules/desktops/hyprland.nix
        ./modules/desktops/kde.nix
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
        inputs.nix-amd-ai.nixosModules.default
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
        inputs.stylix.nixosModules.stylix
        inputs.tss.nixosModules.default
        inputs.nixarr.nixosModules.default
        {
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };
}
