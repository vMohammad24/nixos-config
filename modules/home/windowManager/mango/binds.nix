{...}: let
  mainMod = "SUPER";
in {
  wayland.windowManager.mango.settings = {
    bind =
      [
        # apps
        "${mainMod},T,spawn,uwsm app -- kitty"
        "${mainMod},W,spawn,uwsm app -- firefox"
        "${mainMod},E,spawn,uwsm app -- thunar"
        "${mainMod}+SHIFT,Z,spawn,uwsm app -- zeditor"
        "${mainMod}+SHIFT,S,spawn,uwsm app -- steam"
        "${mainMod}+SHIFT,P,spawn,uwsm app -- prismlauncher"
        "${mainMod}+SHIFT,T,spawn,uwsm app -- feishin"
        "${mainMod}+SHIFT,E,spawn,uwsm app -- discordcanary"
        "${mainMod}+SHIFT,J,spawn,uwsm app -- jellyfin-mpv-shim"

        # power management
        "CTRL+ALT,Delete,spawn,vicinae deeplink vicinae://launch/power"
        "${mainMod},L,spawn_shell,pidof hyprlock || hyprlock"

        # utils
        "${mainMod},P,spawn,hyprpicker -a"
        "${mainMod},V,spawn,vicinae vicinae://launch/clipboard/history"
        "${mainMod},S,spawn_shell,grim -g \"$(slurp)\" - | wl-copy"
        "${mainMod}+ALT,S,spawn_shell,framr -o - | tesseract stdin stdout --psm 6 2>/dev/null | wl-copy"
        "${mainMod},comma,spawn,vicinae vicinae://launch/core/search-emojis"
        "NONE,Print,spawn,framr -u -c -a"
        "CTRL,Print,spawn,framr -u -c --last"
        "${mainMod},Print,spawn,framr --record -u -c -a --container webm"

        # window management
        "${mainMod},Q,killclient"
        "${mainMod}+ALT,Q,killclient,force"
        "${mainMod},M,quit"
        "${mainMod}+SHIFT,R,reload_config"
        "${mainMod},space,togglefloating"
        "${mainMod},F,togglefullscreen"
        "${mainMod},D,togglemaximizescreen"
        "${mainMod}+ALT,F,togglefakefullscreen"
        "ALT,Tab,focusstack,next"
        "CTRL+${mainMod},backslash,resizewin,640,480"

        # focus
        "${mainMod},Left,focusdir,left"
        "${mainMod},Right,focusdir,right"
        "${mainMod},Up,focusdir,up"
        "${mainMod},Down,focusdir,down"
      ]
      ++ (
        # workspaces
        builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              "${mainMod},code:1${toString i},view,${toString ws}"
              "${mainMod}+ALT,code:1${toString i},tag,${toString ws}"
            ]
          )
          9
        )
      )
      ++ [
        # super (app launcher)
        "${mainMod}+ALT,space,spawn,vicinae toggle"
      ];

    # volume, brightness & media controls
    bindl = [
      "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "NONE,XF86MonBrightnessUp,spawn,brightnessctl s 10%+"
      "NONE,XF86MonBrightnessDown,spawn,brightnessctl s 10%-"
      "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "NONE,XF86AudioPlay,spawn,playerctl play-pause"
      "NONE,XF86AudioPrev,spawn,playerctl previous"
      "NONE,XF86AudioNext,spawn,playerctl next"
    ];

    mousebind = [
      "${mainMod},btn_left,moveresize,curmove"
      "${mainMod},btn_right,moveresize,curresize"
    ];
    axisbind = [
      "${mainMod},UP,viewtoleft_have_client"
      "${mainMod},DOWN,viewtoright_have_client"
    ];
  };
}
