{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "battery" "tray"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
        };
        "clock" = {
          format = "{:%H:%M - %a, %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
        };
        "pulseaudio" = {
          format = "{volume}% 🔊";
          format-muted = "Muted 🔇";
          on-click = "pavucontrol";
        };
      };
    };
    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
          font-size: 13px;
          font-weight: bold;
      }
      window#waybar {
          background-color: #191724; /* Base */
          color: #e0def4; /* Text */
          border-bottom: 2px solid #ebbcba; /* Rose Accent */
      }
      #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: #908caa; /* Subtle */
      }
      #workspaces button.active {
          background-color: #ebbcba; /* Rose */
          color: #191724; /* Base */
          border-radius: 0;
      }
      #clock, #pulseaudio, #network, #battery, #tray {
          padding: 0 12px;
          color: #e0def4; /* Text */
      }
      #window {
          margin-left: 20px;
          color: #c4a7e7; /* Iris */
      }
    '';
  };
}
