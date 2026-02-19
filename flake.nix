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
    tidaLuna = {
      url = "github:Inrixia/TidaLuna";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    alejandra,
    tidaLuna,
    ...
  }: {
    nixosConfigurations.hyprland = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit alejandra tidaLuna;};
      modules = [
        ./configuration.nix
        {
          nixpkgs.config.allowUnfree = true;
        }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.vmohammad = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
