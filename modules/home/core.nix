{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  isDesktop = osConfig.myConfig.isDesktop;
  sshKey = {
    IdentityFile = "~/.ssh/id_rsa";
    IdentitiesOnly = "yes";
  };
in {
  home.username = "vmohammad";
  home.homeDirectory = "/home/vmohammad";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.mimeApps = lib.mkIf isDesktop {
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

  xdg.userDirs = lib.mkIf isDesktop {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  xdg.terminal-exec = lib.mkIf isDesktop {
    enable = true;
    settings = {
      default = ["kitty.desktop"];
    };
  };

  gtk = lib.mkIf isDesktop {
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

  programs.mpv = lib.mkIf isDesktop {
    enable = true;
    config = {
      ao = "pipewire";
      audio-samplerate = 0;
      audio-format = "auto";
      audio-swresample-o = "dither_method=triangular";
      volume = 100;
      volume-max = 100;
      vo = "gpu-next";
      gpu-api = "vulkan";
      profile = "high-quality";
      deband = "yes";
      video-sync = "display-resmaple";
      interpolation = "yes";
    };
  };
  programs.mangohud = lib.mkIf isDesktop {
    enable = true;
    enableSessionWide = true;
    settings = {
      no_display = true;
      gui_scaling = 100;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" =
        sshKey
        // {
          HostName = "github.com";
          AddKeysToAgent = "yes";
        };
      "server" =
        sshKey
        // {
          User = "vmohammad";
          HostName = "192.168.1.31";
          Port = 22;
        };
      "rpi" =
        sshKey
        // {
          User = "vmohammad";
          HostName = "192.168.1.32";
          Port = 22;
        };
    };
  };

  programs.framr = lib.mkIf isDesktop {
    enable = true;
    settings = {
      default_uploader = "nest.rip";
      default_action = "UploadAndCopy";
      default_capture = "Area";
      default_screen = 1;

      recording = {
        encoder = "AV1";
        bitrate = 4000;
        keyframe_interval = 60;
        tune = "Zerolatency";
        speed = "Veryfast";
      };

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
    ++ lib.optionals isDesktop [
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
      jetbrains.idea
      discord-canary
      labymod-launcher
      blender
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
