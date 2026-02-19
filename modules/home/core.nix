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
    firefox
    nautilus

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

    # clis
    eza

    # themes
    rose-pine-gtk-theme
    rose-pine-icon-theme
    rose-pine-hyprcursor
  ];
}
