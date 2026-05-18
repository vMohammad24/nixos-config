{pkgs, ...}: {
  stylix.targets = {
    hyprlock.enable = false;
    waybar.enable = false;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };
}
