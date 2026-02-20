{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind =
      [
        # apps
        "$mainMod, T, exec, kitty"
        "$mainMod, W, exec, firefox"
        "$mainMod, E, exec, nautilus"
        "$mainMod, C, exec, code"
        "$mainMod, S, exec, steam"
        "$mainMod SHIFT, T, exec, tidal-hifi"
        "$mainMod SHIFT, E, exec, equibop"

        # utils
        "$mainMod, P, exec, hyprpicker -a"
        "$mainMod, V, exec, cliphist list | fuzzel -d | cliphist decode | wl-copy"
        "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        ", Print, exec, /home/vmohammad/Downloads/grabit/main.sh"

        # window management
        "$mainMod, Q, killactive,"
        "$mainMod ALT, Q, exec, hyprctl kill"
        "$mainMod, M, exit,"
        "$mainMod, SPACE, togglefloating,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, D, fullscreen, 1"
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
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod ALT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

    # super (app launcher)
    bindr = [
      "SUPER, SUPER_L, exec, fuzzel"
    ];

    # mouse
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # audio & brightness
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];
  };
}
