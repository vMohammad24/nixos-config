{...}: {
  wayland.windowManager.mango.settings = {
    window_rule = [
      "is_floating:1,is_global:1,ignore_maximize:1,app_id:^firefox$,title:^Picture-in-Picture$"
    ];

    layer_rule = [
      "no_animation:1,no_blur:1,layer_name:selection"
    ];
  };
}
