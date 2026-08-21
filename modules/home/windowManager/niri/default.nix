{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  spawn = command: {spawn = command;};
  spawnSh = command: {spawn-sh = command;};
  locked = command: {
    _props = {allow-when-locked = true;};
    spawn = command;
  };
  workspaceBinds = builtins.listToAttrs (builtins.concatLists (builtins.genList (
      i: let
        ws = i + 1;
      in [
        {
          name = "Mod+${toString ws}";
          value = {focus-workspace = toString ws;};
        }
        {
          name = "Mod+Alt+${toString ws}";
          value = {move-window-to-workspace = toString ws;};
        }
      ]
    )
    9));
in {
  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      prefer-no-csd = [];

      cursor = {
        xcursor-theme = config.gtk.cursorTheme.name;
        xcursor-size = config.gtk.cursorTheme.size;
      };

      environment = {
        ADW_DISABLE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";
      };

      input = {
        focus-follows-mouse = [];
        mouse = {
          accel-profile = "flat";
          accel-speed = -0.5;
        };
      };

      output = [
        {
          _args = ["DP-1"];
          mode = "2560x1440@240";
          position._props = {
            x = 0;
            y = 0;
          };
          scale = 1.0;
          variable-refresh-rate = [];
        }
        {
          _args = ["DP-2"];
          mode = "1920x1080@144";
          position._props = {
            x = -1080;
            y = 0;
          };
          scale = 1.0;
          transform = "90";
        }
      ];

      workspace =
        builtins.genList (i: {
          _args = [(toString (i + 1))];
        })
        9;

      layout = {
        gaps = 4;
        struts = {
          left = 8;
          right = 8;
          top = 8;
          bottom = 8;
        };
        always-center-single-column = [];
        default-column-width = {proportion = 0.5;};
        preset-column-widths._children = [
          {proportion = 1.0 / 3.0;}
          {proportion = 0.5;}
          {proportion = 2.0 / 3.0;}
        ];
        focus-ring = {
          width = 2;
          active-color = "#${c.base0A}";
          inactive-color = "#${c.base02}";
        };
        border.off = [];
        shadow = {
          on = [];
          softness = 10;
          spread = 0;
          offset._props = {
            x = 0;
            y = 4;
          };
          draw-behind-window = true;
          color = "#00000055";
        };
        background-color = "#${c.base00}";
      };

      animations = {
        workspace-switch.spring._props = {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };
        window-open = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
        window-close = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
        horizontal-view-movement.spring._props = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
        window-movement.spring._props = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
        window-resize.spring._props = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
      };

      spawn-at-startup = [
        ["uwsm" "app" "--" "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"]
        ["uwsm" "app" "--" "udiskie" "--autostart" "--tray" "--notify"]
        ["uwsm" "app" "--" "steam" "-silent"]
      ];

      binds =
        {
          "Mod+T" = spawn ["uwsm" "app" "--" "kitty"];
          "Mod+W" = spawn ["uwsm" "app" "--" "firefox"];
          "Mod+E" = spawn ["uwsm" "app" "--" "thunar"];
          "Mod+Shift+Z" = spawn ["uwsm" "app" "--" "zeditor"];
          "Mod+Shift+S" = spawn ["uwsm" "app" "--" "steam"];
          "Mod+Shift+P" = spawn ["uwsm" "app" "--" "prismlauncher"];
          "Mod+Shift+T" = spawn ["uwsm" "app" "--" "feishin"];
          "Mod+Shift+E" = spawn ["uwsm" "app" "--" "discordcanary"];
          "Mod+Shift+J" = spawn ["uwsm" "app" "--" "jellyfin-desktop"];

          "Mod+Ctrl+Delete" = spawn ["vicinae" "deeplink" "vicinae://launch/power"];
          "Mod+Shift+L" = spawnSh "pidof hyprlock || hyprlock";
          "Mod+P" = spawn ["hyprpicker" "-a"];
          "Mod+V" = spawn ["vicinae" "vicinae://launch/clipboard/history"];
          "Mod+S" = spawnSh "grim -g \"$(slurp)\" - | wl-copy";
          "Mod+Comma" = spawn ["vicinae" "vicinae://launch/core/search-emojis"];
          "Print" = spawn ["framr" "-u" "-c" "-a"];
          "Mod+Print" = spawn ["framr" "--record" "-u" "-c" "-a" "--container" "webm"];

          "Mod+Q" = {close-window = [];};
          "Mod+M" = {quit = [];};
          "Mod+Space" = {toggle-window-floating = [];};
          "Mod+F" = {fullscreen-window = [];};
          "Mod+D" = {maximize-column = [];};
          "Alt+Tab" = {focus-window-down = [];};

          "Mod+l" = {focus-column-left = [];};
          "Mod+r" = {focus-column-right = [];};
          "Mod+u" = {focus-window-up = [];};
          "Mod+Down" = {focus-window-down = [];};
          "Mod+Alt+Space" = spawn ["vicinae" "toggle"];

          "Mod+Shift+Left" = {move-column-left = [];};
          "Mod+Shift+Right" = {move-column-right = [];};
          "Mod+Ctrl+Left" = {consume-or-expel-window-left = [];};
          "Mod+Ctrl+Right" = {consume-or-expel-window-right = [];};
          "Mod+Ctrl+Backslash" = {switch-preset-column-width = [];};

          "XF86AudioRaiseVolume" = locked ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"] // {_props = {repeat = true;};};
          "XF86AudioLowerVolume" = locked ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"] // {_props = {repeat = true;};};
          "XF86MonBrightnessUp" = locked ["brightnessctl" "s" "10%+"] // {_props = {repeat = true;};};
          "XF86MonBrightnessDown" = locked ["brightnessctl" "s" "10%-"] // {_props = {repeat = true;};};
          "XF86AudioMute" = locked ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioPlay" = locked ["playerctl" "play-pause"];
          "XF86AudioPrev" = locked ["playerctl" "previous"];
          "XF86AudioNext" = locked ["playerctl" "next"];
        }
        // workspaceBinds;

      window-rule = [
        {
          geometry-corner-radius = 6;
          clip-to-geometry = true;
        }
        {
          match = {
            _props.app-id._raw = ''r#"^firefox$"#'';
            _props.title._raw = ''r#"^Picture-in-Picture$"#'';
          };
          open-floating = true;
          default-column-width = {proportion = 0.4;};
        }
      ];
    };
  };
}
