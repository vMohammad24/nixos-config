{...}: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind =
      [
        # apps
        "$mainMod, T, exec, uwsm app -- kitty"
        "$mainMod, W, exec, uwsm app -- firefox"
        "$mainMod, E, exec, uwsm app -- thunar"
        "$mainMod SHIFT, Z, exec, uwsm app -- zeditor"
        "$mainMod SHIFT, S, exec, uwsm app -- steam"
        "$mainMod SHIFT, P, exec, uwsm app -- prismlauncher"
        "$mainMod SHIFT, T, exec, uwsm app -- high-tide"
        "$mainMod SHIFT, E, exec, uwsm app -- equibop"
        # app keybinds
        ", Scroll_Lock, exec, equibop --toggle-deafen"

        # wlogout
        "CTRL ALT, delete, exec, wlogout"

        # utils
        "$mainMod, P, exec, hyprpicker -a"
        "$mainMod, V, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
        "$mainMod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mainMod, comma, exec, vicinae vicinae://extensions/vicinae/core/search-emojis"
        ", Print, exec, grabit -p --freeze"
        "$mainMod, Print, exec, grabit --record"
        # window management
        "$mainMod, Q, killactive,"
        "$mainMod ALT, Q, exec, hyprctl kill"
        "$mainMod, M, exit,"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, D, fullscreen, 1"
        "$mainMod ALT, F, fullscreenstate, 0 3"
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "Ctrl $mainMod, Backslash, resizeactive, exact 640 480"

        # focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ]
      ++ (
        # workspaces (from https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#usage)
        # binds $mod + [alt +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod ALT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        )
      );

    # super (app launcher)
    bindr = [
      "SUPER, SUPER_L, exec, vicinae toggle"
    ];

    # mouse
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # volume & brightness (repeat on hold)
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];

    # media controls (locked, no repeat)
    bindl = [
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioPlay, exec, playerctl play-pause"
      ",XF86AudioPrev, exec, playerctl previous"
      ",XF86AudioNext, exec, playerctl next"
    ];
  };
}
