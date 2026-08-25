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
    programs.uwsm.waylandCompositors.mango = {
      prettyName = "Mango";
      comment = "Mango compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/mango";
    };
    programs.mango.enable = true;

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
    };

    home-manager.users.vmohammad = {
      imports = [
        ../../modules/home/windowManager/mango
      ];
    };
  };
}
