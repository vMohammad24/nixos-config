{lib, ...}: let
  mainMod = "SUPER";
  h = import ./helpers.nix {inherit lib;};
  repeatLocked = {
    repeating = true;
    locked = true;
  };
  locked = {locked = true;};
in {
  wayland.windowManager.hyprland.settings = {
    mainMod = {
      _var = mainMod;
    };

    bind =
      [
        # apps
        (h.bindExec "T" "uwsm app -- kitty")
        (h.bindExec "W" "uwsm app -- firefox")
        (h.bindExec "E" "uwsm app -- thunar")
        (h.bindExec "SHIFT + Z" "uwsm app -- zeditor")
        (h.bindExec "SHIFT + S" "uwsm app -- steam")
        (h.bindExec "SHIFT + P" "uwsm app -- prismlauncher")
        (h.bindExec "SHIFT + T" "uwsm app -- feishin")
        (h.bindExec "SHIFT + E" "uwsm app -- discordcanary")

        # power management
        (h.bind "\"CTRL + ALT + delete\"" "hl.dsp.exec_cmd(\"vicinae deeplink vicinae://launch/power\")")
        (h.bindExec "L" "pidof hyprlock || hyprlock")

        # utils
        (h.bindExec "P" "hyprpicker -a")
        (h.bindExec "V" "vicinae vicinae://launch/clipboard/history")
        (h.bindExec "S" "grim -g \\\"$(slurp)\\\" - | wl-copy")
        (h.bindExec "comma" "vicinae vicinae://launch/core/search-emojis")
        (h.bind "\"Print\"" "hl.dsp.exec_cmd(\"framr -u -c -a\")")
        (h.bindExec "Print" "framr --record -u -c -a --container webm")

        # window management
        (h.bindWindow "Q" "close")
        (h.bindMod "ALT + Q" "hl.dsp.exec_cmd(\"hyprctl kill\")")
        (h.bindWindow "M" "exit")
        (h.bindWindow "SPACE" "float")
        (h.bindWindow "F" "fullscreen")
        (h.bindWindow "D" "maximize")
        (h.bindMod "ALT + F" "hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = \"toggle\" })")
        (h.bind "\"ALT + Tab\"" "hl.dsp.window.cycle_next()")
        (h.bind "\"ALT + Tab\"" "hl.dsp.window.alter_zorder({ mode = \"top\" })")
        (h.bind "\"CTRL + \" .. mainMod .. \" + Backslash\"" "hl.dsp.window.resize({ x = 640, y = 480, exact = true })")

        # focus
        (h.bindFocus "left" "l")
        (h.bindFocus "right" "r")
        (h.bindFocus "up" "u")
        (h.bindFocus "down" "d")
      ]
      ++ (
        builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              (h.bindWorkspace "code:1${toString i}" ws)
              (h.bindMoveToWorkspace "ALT + code:1${toString i}" ws)
            ]
          )
          9
        )
      )
      ++ [
        # super (app launcher)
        (h.bindModFlags "SUPER_L" "hl.dsp.exec_cmd(\"vicinae toggle\")" {release = true;})

        # mouse
        (h.bindModFlags "mouse:272" "hl.dsp.window.drag()" {mouse = true;})
        (h.bindModFlags "mouse:273" "hl.dsp.window.resize()" {mouse = true;})

        # volume & brightness
        (h.bindFlags "\"XF86AudioRaiseVolume\"" "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\")" repeatLocked)
        (h.bindFlags "\"XF86AudioLowerVolume\"" "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")" repeatLocked)
        (h.bindFlags "\"XF86MonBrightnessUp\"" "hl.dsp.exec_cmd(\"brightnessctl s 10%+\")" repeatLocked)
        (h.bindFlags "\"XF86MonBrightnessDown\"" "hl.dsp.exec_cmd(\"brightnessctl s 10%-\")" repeatLocked)

        # media controls
        (h.bindFlags "\"XF86AudioMute\"" "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")" locked)
        (h.bindFlags "\"XF86AudioPlay\"" "hl.dsp.exec_cmd(\"playerctl play-pause\")" locked)
        (h.bindFlags "\"XF86AudioPrev\"" "hl.dsp.exec_cmd(\"playerctl previous\")" locked)
        (h.bindFlags "\"XF86AudioNext\"" "hl.dsp.exec_cmd(\"playerctl next\")" locked)
      ];
  };
}
