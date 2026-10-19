{...}: {
  wayland.windowManager.mango.settings = {
    monitor_rule = [
      "name:^DP-1$,width:2560,height:1440,refresh:240,x:1080,y:0,scale:1,vrr:1,primary:1"
      "name:^DP-2$,width:1920,height:1080,refresh:144,x:0,y:0,scale:1,rr:1"
    ];

    tag_rule = [
      "id:*,layout_name:dwindle"
      "id:1,monitor_name:DP-1,layout_name:dwindle,no_hide:1"
      "id:2,monitor_name:DP-2,layout_name:dwindle,no_hide:1"
    ];
  };
}
