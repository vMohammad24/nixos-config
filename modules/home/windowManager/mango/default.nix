{
  config,
  inputs,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  imports = [
    inputs.mangowm.hmModules.mango
    ./monitors.nix
    ./env.nix
    ./startup.nix
    ./binds.nix
    ./animations.nix
    ./rules.nix
  ];

  wayland.windowManager.mango = {
    enable = true;
    package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
    systemd.enable = false; # managed by uwsm

    settings = {
      # reload & layout
      auto_reload_config = 1;
      circle_layout = "dwindle,tile,scroller,monocle";
      dwindle_split_ratio = 0.5;
      dwindle_smart_split = 0;
      dwindle_preserve_split = 1;
      gap_inner_horizontal = 4;
      gap_inner_vertical = 4;
      gap_outer_horizontal = 8;
      gap_outer_vertical = 8;
      border_px = 2;
      border_radius = 6;

      root_color = "0x${c.base00}ff";
      border_color = "0x${c.base02}ff";
      focus_color = "0x${c.base0A}ff";
      urgent_color = "0x${c.base08}ff";
      maximized_screen_color = "0x${c.base0B}ff";
      scratchpad_color = "0x${c.base0D}ff";
      global_color = "0x${c.base0E}ff";
      overlay_color = "0x${c.base0C}ff";

      cursor_theme = config.stylix.cursor.name;
      cursor_size = config.stylix.cursor.size;

      blur = 1;
      blur_layer = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 8;
        num_passes = 2;
      };
      shadows = 1;
      layer_shadows = 0;
      shadow_only_floating = 0;
      shadows_size = 10;
      shadows_blur = 15;
      shadows_position_x = 0;
      shadows_position_y = 0;
      shadows_color = "0x00000055";
      focused_opacity = 1.0;
      unfocused_opacity = 1.0;
      mouse_accel_profile = 1;
      mouse_accel_speed = -0.5;
      allow_tearing = 1;
      sync_obj_enable = 1;
      xwayland_persistence = 1;
      focus_on_activate = 1;
      sloppy_focus = 1;
      warp_cursor = 0;
      focus_cross_monitor = 1;
      exchange_cross_monitor = 1;
    };
  };
}
