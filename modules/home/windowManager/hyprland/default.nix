{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./monitors.nix
    ./env.nix
    ./startup.nix
    ./binds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # for uwsm

    settings = {
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(ebbcbaff)";
        "col.inactive_border" = "rgba(26233aff)";
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
          color = "rgba(00000055)";
        };
      };
    };
  };
}
