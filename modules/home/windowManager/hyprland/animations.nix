{...}: {
  wayland.windowManager.hyprland.settings = {
    animations = {
      enabled = true;

      bezier = [
        "smoothOut, 0.25, 0.8, 0.2, 1"
        "quickInOut, 0.4, 0, 0.6, 1"
      ];

      animation = [
        "global, 1, 4, smoothOut"
        "windows, 1, 5, smoothOut, popin 80%"
        "windowsIn, 1, 5, smoothOut, popin 80%"
        "windowsOut, 1, 3, quickInOut, popin 80%"
        "border, 1, 2, quickInOut"
        "fadeIn, 1, 3, smoothOut"
        "fadeOut, 1, 2, quickInOut"
        "fade, 1, 3, smoothOut"
        "layers, 1, 4, smoothOut"
        "layersIn, 1, 4, smoothOut"
        "layersOut, 1, 3, quickInOut"
        "workspaces, 1, 4, smoothOut"
        "workspacesIn, 1, 4, smoothOut"
        "workspacesOut, 1, 4, smoothOut"
        "zoomFactor, 1, 5, smoothOut"
        "specialWorkspace, 1, 2, quickInOut, slidevert"
      ];
    };
  };
}
