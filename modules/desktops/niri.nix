{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.desktops.niri;
in {
  options.myConfig.desktops.niri = {
    enable = lib.mkEnableOption "Niri WM environment";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri-nix];

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      withUWSM = true;
    };

    home-manager.users.vmohammad = {
      home.packages = [pkgs.xwayland-satellite-unstable];
      imports = [
        inputs.niri.homeModules.niri-nix
        ../../modules/home/windowManager/niri
        ../../modules/home/services/hyprpaper.nix
        ../../modules/home/services/hypridle.nix
        ../../modules/home/services/hyprlock.nix
        ../../modules/home/programs/bars/waybar.nix
        ../../modules/home/services/mako.nix
      ];
    };
  };
}
