{pkgs, ...}: {
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  stylix.targets = {
    hyprlock.enable = false;
    waybar.enable = false;
  };
}
