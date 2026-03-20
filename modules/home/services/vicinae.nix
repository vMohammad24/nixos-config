{
  inputs,
  pkgs,
  ...
}: {
  programs.vicinae = {
    enable = true;
    package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
        developer = {
          enabled = false;
          entrypoints = {
            create = {
              enabled = false;
            };
          };
        };
        files = {
          preferences = {
            autoIndexing = true;
            excludedPaths = "/nix/store";
            paths = "~/";
            watcherPaths = "";
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
          };
        };
        system = {
          enabled = false;
        };
      };
    };
    systemd = {
      enable = false;
    };
  };
}
