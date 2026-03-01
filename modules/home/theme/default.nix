{
  config,
  pkgs,
  ...
}: let
  t = config.theme;
in {
  imports = [./colors.nix];

  gtk = {
    enable = true;
    theme = {
      name = t.name;
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = t.name;
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = t.cursor.name;
      package = pkgs.rose-pine-hyprcursor;
      size = t.cursor.size;
    };
    font = {
      name = t.font.name;
      size = t.font.size;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = t.cursor.name;
    package = pkgs.rose-pine-hyprcursor;
    size = t.cursor.size;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = t.name;
      font-name = "${t.font.name} ${toString t.font.size}";
      document-font-name = "${t.font.name} ${toString t.font.size}";
      monospace-font-name = "${t.font.name} ${toString t.font.size}";
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${pkgs.rose-pine-gtk-theme}/share/themes/${t.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/${t.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${pkgs.rose-pine-gtk-theme}/share/themes/${t.name}/gtk-4.0/gtk-dark.css";
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
    '';
  };
}
