{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  stylix.targets = lib.mkIf osConfig.myConfig.isDesktop {
    hyprlock.enable = false;
    waybar.enable = false;
  };
}
