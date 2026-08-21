{osConfig, ...}: let
  niriEnabled = osConfig.myConfig.desktops.niri.enable or false;
  powerOnMonitors =
    if niriEnabled
    then "niri msg action power-on-monitors"
    else "hyprctl dispatch dpms on";
  powerOffMonitors =
    if niriEnabled
    then "niri msg action power-off-monitors"
    else "hyprctl dispatch dpms off";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = powerOnMonitors;
      };

      listener = [
        {
          timeout = 240;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = powerOffMonitors;
          on-resume = powerOnMonitors;
        }
      ];
    };
  };
}
