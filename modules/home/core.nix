{
  pkgs,
  config,
  ...
}: {
  home.username = "vmohammad";
  home.homeDirectory = "/home/vmohammad";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = ["firefox.desktop"];
      "application/json" = ["dev.zed.Zed.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "application/pdf" = ["firefox.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "image/jpeg" = ["qview.desktop"];
      "image/png" = ["qview.desktop"];
      "image/webp" = ["qview.desktop"];
      "image/gif" = ["qview.desktop"];
      "image/svg+xml" = ["qview.desktop"];
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  gtk = {
    enable = true;
    gtk3.bookmarks = let
      home = config.home.homeDirectory;
    in
      map (dir: "file://${home}/${dir}") [
        "Documents"
        "Downloads"
        "Pictures"
      ];
  };

  programs.fastfetch.enable = true;
  programs.eza.enable = true;
  programs.mpv.enable = true;
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      no_display = true;
      gui_scaling = 100;
    };
  };

  home.packages = with pkgs; [
    # core
    thunar
    udiskie

    # apps
    hyprpolkitagent
    protonup-rs
    wayland-utils
    glib
    glib-networking
    wivrn
    bs-manager
    teamspeak6-client
    qview
    bruno
    feishin
    mitmproxy
    mullvad-vpn
    prismlauncher
    watchexec
    jetbrains-toolbox

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
  ];
}
