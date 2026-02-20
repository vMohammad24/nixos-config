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

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-lgc-plus
    ibm-plex
    amiri
  ];

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    GIO_EXTRA_MODULES = ["${pkgs.glib-networking}/lib/gio/modules"];
  };
}
