{pkgs, ...}: {
  stylix.targets = {
    hyprlock.enable = false;
    waybar.enable = false;
    gtk.enable = false;
  };

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "rose-pine";
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk-dark.css";
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
    '';
  };
}
