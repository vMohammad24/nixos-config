{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.desktops.mango;
in {
  options.myConfig.desktops.mango = {
    enable = lib.mkEnableOption "Mango WM environment";
  };

  config = lib.mkIf cfg.enable {
    programs.uwsm.enable = true;
    programs.mango.enable = true;

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
    };

    home-manager.users.vmohammad = {
      imports = [
        ../../modules/home/windowManager/mango
        ../../modules/home/services/hyprpaper.nix
        ../../modules/home/services/hypridle.nix
        ../../modules/home/services/hyprlock.nix
        ../../modules/home/programs/bars/waybar.nix
        ../../modules/home/services/mako.nix
      ];
    };
  };
}
