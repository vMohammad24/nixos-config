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

      @define-color base            #191724;
      @define-color surface         #1f1d2e;
      @define-color overlay         #26233a;

      @define-color muted           #6e6a86;
      @define-color subtle          #908caa;
      @define-color text            #e0def4;

      @define-color love            #eb6f92;
      @define-color gold            #f6c177;
      @define-color rose            #ebbcba;
      @define-color pine            #31748f;
      @define-color foam            #9ccfd8;
      @define-color iris            #c4a7e7;

      @define-color highlightLow    #21202e;
      @define-color highlightMed    #403d52;
      @define-color highlightHigh   #524f67;
      * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
          font-weight: bold;
      }
      window#waybar {
          background-color: rgba(25, 23, 36, 0.85); /* base but 0.85 */
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
          background-color: rgba(235, 188, 186, 0.1); /* rose but low opacity */
          color: @rose;
          border-bottom: 3px solid @rose;
          border-radius: 0;
      }
      #workspaces button:hover {
          background-color: rgba(235, 188, 186, 0.2);
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
