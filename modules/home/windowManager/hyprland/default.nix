{
  config,
  lib,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  imports = [
    ./monitors.nix
    ./env.nix
    ./startup.nix
    ./binds.nix
    ./animations.nix
    ./rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # for uwsm

    settings = {
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgba(${c.base0A}ff)";
        "col.inactive_border" = lib.mkForce "rgba(${c.base02}ff)";
        layout = "dwindle";
        allow_tearing = true;
      };

      decoration = {
        rounding = 6;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 10;
          render_power = 3;
          color = lib.mkForce "rgba(00000055)";
        };
      };

      input = {
        sensitivity = -0.5;
        accel_profile = "flat";
      };

      misc = {
        focus_on_activate = true;
      };
    };
  };
}
