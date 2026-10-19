{...}: let
  smoothOut = "0.25,0.8,0.2,1.0";
  quickInOut = "0.4,0.0,0.6,1.0";
in {
  wayland.windowManager.mango.settings = {
    animations = 1;
    layer_animations = 1;
    animation_type_open = "zoom";
    animation_type_close = "zoom";
    layer_animation_type_open = "slide";
    layer_animation_type_close = "slide";
    animation_fade_in = 1;
    animation_fade_out = 1;
    tag_animation_direction = 1;
    zoom_initial_ratio = 0.8;
    zoom_end_ratio = 0.8;
    fade_in_begin_opacity = 0.5;
    fade_out_begin_opacity = 0.8;
    animation_duration_open = 500;
    animation_duration_move = 500;
    animation_duration_tag = 400;
    animation_duration_close = 300;
    animation_duration_focus = 200;
    animation_curve = {
      open = smoothOut;
      move = smoothOut;
      tag = smoothOut;
      close = quickInOut;
      focus = quickInOut;
      opacity_fade_in = smoothOut;
      opacity_fade_out = quickInOut;
    };
  };
}
