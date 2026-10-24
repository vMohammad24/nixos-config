{pkgs, ...}: {
  networking.firewall.allowedTCPPorts = [
    3000
    25565
  ];
  networking.firewall.allowedUDPPorts = [25565];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = ["*"];
  };

  fonts = {
    packages = with pkgs; [
      geist-font
      nerd-fonts.geist-mono
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
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

  environment.variables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0";
}
