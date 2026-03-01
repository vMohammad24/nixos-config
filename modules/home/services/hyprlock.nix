{
  config,
  pkgs,
  ...
}: let
  c = config.theme.colors;
  t = config.theme;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };

      background = [
        {
          path = "${config.home.homeDirectory}/Pictures/wallpaper.png";
          blur_passes = 3;
          blur_size = 8;
          noise = 1.17e-2;
          contrast = 0.8916;
          brightness = 0.7;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgb(${c.rose})";
          inner_color = "rgb(${c.surface})";
          font_color = "rgb(${c.text})";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          check_color = "rgb(${c.gold})";
          fail_color = "rgb(${c.love})";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "rgb(${c.gold})";
          position = "0, -20";
          halign = "center";
          valign = "center";
          rounding = t.rounding;
        }
      ];

      label = [
        # time
        {
          text = "cmd[update:1000] date +\"%H:%M\"";
          color = "rgb(${c.text})";
          font_size = 90;
          font_family = t.font.name;
          position = "0, 200";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgb(${c.base})";
        }
        # date
        {
          text = "cmd[update:60000] date +\"%A, %d %B\"";
          color = "rgb(${c.subtle})";
          font_size = 20;
          font_family = t.font.name;
          position = "0, 130";
          halign = "center";
          valign = "center";
        }
        # hi
        {
          text = "Hi, $USER";
          color = "rgb(${c.rose})";
          font_size = 16;
          font_family = t.font.name;
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
