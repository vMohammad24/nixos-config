{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myConfig.desktops.mango;
  mangoPkg = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
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
    programs.mango = {
      enable = true;
      package = mangoPkg;
    };

    xdg.portal = {
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
      config.mango = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      };
    };

    home-manager.users.vmohammad = {
      imports = [
        ../../modules/home/windowManager/mango
      ];
    };
  };
}
