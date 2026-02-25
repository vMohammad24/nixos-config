{
  config,
  pkgs,
  ...
}: {
  home.username = "vmohammad";
  home.homeDirectory = "/home/vmohammad";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # core
    kitty
    nautilus
    udiskie

    # apps
    zed-editor
    helix
    foot
    hyprpolkitagent
    protonup-rs
    mangohud
    wayland-utils
    glib
    nodejs_24
    bun
    glib-networking
    wivrn
    bs-manager
    teamspeak6-client
    qview

    # utils/essentials
    waybar
    fuzzel
    mako
    hyprpaper
    hyprpicker
    libnotify
    pavucontrol
    brightnessctl

    #  screenshot & clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # clis
    eza

    # themes
    rose-pine-gtk-theme
    rose-pine-icon-theme
    rose-pine-hyprcursor
  ];
}
