{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.myConfig.desktop == "hyprland") {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
