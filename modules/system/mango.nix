{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.myConfig.desktop == "mango") {
    programs.uwsm.enable = true;
    programs.mango.enable = true;
    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
