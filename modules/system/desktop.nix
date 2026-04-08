{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
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
      vazir-fonts
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
