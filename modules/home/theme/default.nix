{pkgs, ...}: {
  gtk = {
    enable = true;
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
