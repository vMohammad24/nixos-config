{
  config,
  pkgs,
  ...
}: {
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
    cursorTheme = {
      name = "rose-pine-hyprcursor";
      package = pkgs.rose-pine-hyprcursor;
      size = 24;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "rose-pine-hyprcursor";
    package = pkgs.rose-pine-hyprcursor;
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "rose-pine";
      font-name = "JetBrainsMono Nerd Font 11";
      document-font-name = "JetBrainsMono Nerd Font 11";
      monospace-font-name = "JetBrainsMono Nerd Font 11";
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
