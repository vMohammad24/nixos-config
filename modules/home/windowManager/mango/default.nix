{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./binds.nix
    ./monitors.nix
    inputs.mangowm.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = false;

    settings = {
      gappih = 4;
      gappiv = 4;
      gappoh = 8;
      gappov = 8;
      borderpx = 2;
      border_radius = 6;
      circle_layout = "dwindle";

      blur = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 8;
        num_passes = 2;
      };
      focused_opacity = 1.0;

      mouse_accel_speed = -0.5;
      mouse_accel_profile = 0;

      focus_on_activate = 1;
    };

    autostart_sh = ''
      uwsm app -- ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent &
      uwsm app -- udiskie --autostart --tray --notify &
      uwsm app -- vicinae server &
      uwsm app -- steam -silent &
    '';
  };
}
