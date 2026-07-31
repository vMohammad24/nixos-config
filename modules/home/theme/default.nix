{pkgs, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  stylix.polarity = "dark";
  stylix.targets = {
    hyprlock.enable = false;
    waybar.enable = false;
    qt.enable = true;
  };

  # leave this here until #2407 is merged
  home.pointerCursor.enable = true;
}
