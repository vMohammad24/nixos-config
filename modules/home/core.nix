{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: {
  home.username = "vmohammad";
  home.homeDirectory = "/home/vmohammad";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.mimeApps = lib.mkIf osConfig.myConfig.isDesktop {
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

  xdg.userDirs = lib.mkIf osConfig.myConfig.isDesktop {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  xdg.terminal-exec = lib.mkIf osConfig.myConfig.isDesktop {
    enable = true;
    settings = {
      default = ["kitty.desktop"];
    };
  };

  gtk = lib.mkIf osConfig.myConfig.isDesktop {
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

  programs.mpv.enable = osConfig.myConfig.isDesktop;
  programs.mangohud = lib.mkIf osConfig.myConfig.isDesktop {
    enable = true;
    enableSessionWide = true;
    settings = {
      no_display = true;
      gui_scaling = 100;
    };
  };

  programs.framr = lib.mkIf osConfig.myConfig.isDesktop {
    enable = true;
    settings = {
      default_uploader = "nest.rip";
      default_action = "UploadAndCopy";
      default_capture = "Area";
      default_screen = 1;
      uploaders = [
        {
          name = "nest.rip";
          request_method = "POST";
          request_url = "https://nest.rip/api/files/upload";
          parameters = [];
          headers = [["Authorization" "file:/run/agenix/nest_api_key"]];
          body_type = "FormData";
          arguments = [];
          file_form_name = "files";
          output_url = "{json:fileURL}";
          error_message = "{json:message}";
        }
      ];
    };
  };

  home.packages = with pkgs;
    [
      rclone
      rsrpc
      watchexec
      glib
      glib-networking
    ]
    ++ lib.optionals osConfig.myConfig.isDesktop [
      # core
      thunar
      udiskie

      # apps
      hyprpolkitagent
      protonup-rs
      wayland-utils
      bs-manager
      teamspeak6-client
      qview
      bruno
      feishin
      mitmproxy
      mullvad-vpn
      prismlauncher
      jetbrains-toolbox
      discord-canary
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
