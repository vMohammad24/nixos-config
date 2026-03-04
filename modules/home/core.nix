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
    nautilus
    udiskie

    # apps
    helix
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

    # themes
    rose-pine-gtk-theme
    rose-pine-icon-theme
    rose-pine-hyprcursor
  ];
}
