{
  lib,
  config,
  inputs,
  ...
}: let
  mediaDir = "/mnt/HDD/media";
  stateDir = "/mnt/HDD/.state/nixarr";
  cfg = config.myConfig.rr;
  mediaServices = [
    "jellyfin"
    "sonarr"
    "sonarr-sync-config"
    "radarr"
    "radarr-sync-config"
    "prowlarr"
    "prowlarr-sync-config"
    "bazarr"
    "bazarr-sync-config"
    "seerr"
    "qbittorrent"
    "qui"
    "recyclarr"
    "recyclarr-setup"
  ];
in {
  imports = [inputs.nixarr.nixosModules.default];

  options.myConfig.rr.enable = lib.mkEnableOption "arr media stack";

  config = lib.mkIf cfg.enable {
    nixarr = {
      enable = true;
      inherit mediaDir stateDir;

      jellyfin.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      seerr.enable = true;
      prowlarr = {
        enable = true;
        settings-sync = {
          enable-nixarr-apps = true;
          indexers = [
            {
              sort_name = "milkie";
              fields.apikey.secret = "/run/agenix/prowlarr-milkie-apikey";
            }
            {
              sort_name = "torrentleech";
              fields = {
                username = "vMohammad";
                password.secret = "/run/agenix/prowlarr-torrentleech-password";
                alt2fatoken.secret = "/run/agenix/prowlarr-torrentleech-2fa";
              };
            }
            {
              sort_name = "seedpool api";
              fields.apikey.secret = "/run/agenix/prowlarr-seedpool-apikey";
            }
          ];
        };
      };

      bazarr = {
        enable = true;
        settings-sync = {
          radarr.enable = true;
          sonarr.enable = true;
        };
      };

      qbittorrent = {
        enable = true;
        vpn.enable = true;
        openFirewall = true;
      };

      vpn = {
        enable = true;
        wgConf = "/run/agenix/mullvad-wg";
      };

      recyclarr = {
        enable = true;
        configuration = {
          sonarr.main = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            quality_definition.type = "series";
          };
          radarr.main = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition.type = "movie";
          };
        };
      };

      exporters.enable = true;
    };

    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
    services.radarr.settings.auth.required = "DisabledForLocalAddresses";
    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";

    services.nginx.virtualHosts."127.0.0.1:9586".listen = lib.mkForce [
      {
        addr = "127.0.0.1";
        port = 9586;
      }
    ];

    systemd.services =
      lib.genAttrs mediaServices (_: {
        unitConfig.RequiresMountsFor = [mediaDir stateDir];
      })
      // {
        qbittorrent = {
          unitConfig.RequiresMountsFor = [mediaDir stateDir];
          serviceConfig = {
            CapabilityBoundingSet = lib.mkForce ["CAP_NET_RAW"];
            AmbientCapabilities = lib.mkForce ["CAP_NET_RAW"];
            RestrictAddressFamilies = lib.mkForce ["AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK"];
            InaccessiblePaths = lib.mkForce [];
          };
        };
      };
  };
}
