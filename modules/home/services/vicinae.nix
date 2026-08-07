{...}: let
  powerCmd = cmd: {
    preferences = {
      customProgram = cmd;
      confirm = false;
    };
  };
in {
  programs.vicinae = {
    enable = true;
    enableSoulver = true;
    settings = {
      close_on_focus_loss = false;
      activate_on_single_click = true;
      favicon_service = "google";
      telemetry = {
        system_info = false;
      };
      providers = {
        applications = {
          preferences = {
            defaultAction = "focus";
            launchPrefix = "uwsm app --";
          };
        };
        clipboard = {
          entrypoints = {
            history = {
              preferences = {
                defaultAction = "copy";
              };
            };
          };
        };
        core = {
          entrypoints = {
            sponsor = {
              enabled = false;
            };
          };
        };
        files = {
          preferences = {
            autoIndexing = true;
            excludedIndexingPaths = ["/nix/store" "/mnt"];
            indexingPaths = "/home/vmohammad";
          };
        };
        font = {
          enabled = false;
        };
        power = {
          entrypoints = {
            hibernate = {
              enabled = false;
            };
            suspend = {
              enabled = false;
            };
            "soft-reboot" = {
              enabled = false;
            };
            logout = powerCmd "uwsm stop";
            lock = powerCmd "pidof hyprlock || hyprlock";
            "power-off" = powerCmd "systemctl poweroff";
            reboot = powerCmd "systemctl reboot";
          };
        };
        system = {
          enabled = false;
        };
      };
    };

    systemd = {
      enable = true;
      autoStart = true;
    };
  };
}
