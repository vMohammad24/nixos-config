{ pkgs, ... }:
{
  home.username = "vmohammad";
  home.homeDirectory = "/home/vmohammad";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = [ "firefox.desktop" ];
      "application/json" = [ "dev.zed.Zed.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "image/jpeg" = [ "qview.desktop" ];
      "image/png" = [ "qview.desktop" ];
      "image/webp" = [ "qview.desktop" ];
      "image/gif" = [ "qview.desktop" ];
      "image/svg+xml" = [ "qview.desktop" ];
    };
  };

  home.packages = with pkgs; [
    # core
    nautilus
    udiskie

    # apps
    hyprpolkitagent
    protonup-rs
    mangohud
    wayland-utils
    glib
    glib-networking
    wivrn
    bs-manager
    teamspeak6-client
    qview
    mpv
    bruno

    # utils/essentials
    hyprpicker
    libnotify
    pavucontrol
    brightnessctl
    playerctl

    #  screenshot & clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # clis
    eza
  ];
}
