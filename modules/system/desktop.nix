{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = ["*"];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-lgc-plus
      ibm-plex
      vazirmatn
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "JetBrains Mono"
          "IBM Plex Mono"
          "Vazirmatn"
          "Noto Sans Mono"
        ];

        sansSerif = [
          "IBM Plex Sans"
          "Vazirmatn"
          "Noto Sans Arabic"
        ];

        serif = [
          "IBM Plex Serif"
          "Noto Kufi Arabic"
          "Vazirmatn"
        ];
      };
    };
  };

  environment.sessionVariables = {
    GIO_EXTRA_MODULES = ["${pkgs.glib-networking}/lib/gio/modules"];
  };
}
