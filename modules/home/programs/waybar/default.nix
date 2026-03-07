{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
in {
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
        modules-right = ["mpris" "pulseaudio" "cpu" "memory" "tray"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
        };
        "clock" = {
          format = " {:%H:%M   %a, %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
        };
        "mpris" = {
          format = "{status_icon} {title} - {artist}";
          player-icons = {
            default = "󰎆";
          };
          status-icons = {
            paused = "󰐊";
            playing = "󰏤";
          };
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            headphone = "";

            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        "cpu" = {
          format = " {usage}%";
          tooltip = false;
        };
        "memory" = {
          format = " {used}/{total}GB";
          tooltip = false;
        };
        "tray" = {
          icon-size = 16;
        };
      };
    };
    style = ''

      @define-color base            #${c.base00};
      @define-color surface         #${c.base01};
      @define-color overlay         #${c.base02};

      @define-color muted           #${c.base03};
      @define-color subtle          #${c.base04};
      @define-color text            #${c.base05};

      @define-color love            #${c.base08};
      @define-color gold            #${c.base09};
      @define-color rose            #${c.base0A};
      @define-color pine            #${c.base0B};
      @define-color foam            #${c.base0C};
      @define-color iris            #${c.base0D};

      @define-color highlightLow    #${c.base01};
      @define-color highlightMed    #${c.base02};
      @define-color highlightHigh   #${c.base07};
      * {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 13px;
          font-weight: bold;
      }
      window#waybar {
          background-color: rgba(${c.base00-rgb-r}, ${c.base00-rgb-g}, ${c.base00-rgb-b}, 0.85);
          color: @text;
          border-bottom: 2px solid @rose;
          transition-property: background-color;
          transition-duration: .5s;
      }
      #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: @subtle;
          border-bottom: 3px solid transparent;
          transition: all 0.3s ease;
      }
      #workspaces button.active {
          background-color: rgba(${c.base0A-rgb-r}, ${c.base0A-rgb-g}, ${c.base0A-rgb-b}, 0.1);
          color: @rose;
          border-bottom: 3px solid @rose;
          border-radius: 0;
      }
      #workspaces button:hover {
          background-color: rgba(${c.base0A-rgb-r}, ${c.base0A-rgb-g}, ${c.base0A-rgb-b}, 0.2);
          color: @text;
          box-shadow: inherit;
          text-shadow: inherit;
      }
      #clock, #pulseaudio, #cpu, #memory, #network, #battery, #tray, #mpris {
          padding: 0 12px;
          margin: 4px 0;
          color: @text;
      }
      #mpris {
          color: @gold;
      }
      #pulseaudio {
          color: @rose;
      }
      #cpu {
          color: @pine;
      }
      #memory {
          color: @foam;
      }
      #window {
          margin-left: 20px;
          color: @iris;
      }
      #tray {
          margin-right: 10px;
      }
    '';
  };
}
