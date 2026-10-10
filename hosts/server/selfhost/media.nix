{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  mediaDir = "/mnt/HDD/media";
  stateDir = "/mnt/HDD/.state/nixarr";
  cfg = config.myConfig.rr;
  flaresolverrPort = 8191;
  syncProwlarrFlareSolverr = pkgs.writeShellApplication {
    name = "sync-prowlarr-flaresolverr";
    runtimeInputs = [pkgs.curl pkgs.jq];
    text = ''
      api_key=$(<${stateDir}/secrets/prowlarr.api-key)
      prowlarr_api=http://127.0.0.1:9696/api/v1
      flaresolverr_url=http://127.0.0.1:${toString flaresolverrPort}
      curl_args=(
        --fail-with-body
        --silent
        --show-error
        --header "X-Api-Key: $api_key"
      )

      curl \
        --fail \
        --silent \
        --show-error \
        --retry 30 \
        --retry-all-errors \
        --retry-delay 1 \
        --max-time 5 \
        "$flaresolverr_url/health" \
        > /dev/null

      proxies=$(curl "''${curl_args[@]}" "$prowlarr_api/indexerProxy")
      proxy=$(printf '%s' "$proxies" | jq -c 'first(.[] | select(.name == "FlareSolverr")) // empty')

      if [ -z "$proxy" ]; then
        schemas=$(curl "''${curl_args[@]}" "$prowlarr_api/indexerProxy/schema")
        proxy=$(printf '%s' "$schemas" | jq -c 'first(.[] | select(.implementation == "FlareSolverr")) // empty')
      fi

      if [ -z "$proxy" ]; then
        echo "Prowlarr did not return the FlareSolverr indexer-proxy schema" >&2
        exit 1
      fi

      tags=$(curl "''${curl_args[@]}" "$prowlarr_api/tag")
      tag_id=$(printf '%s' "$tags" | jq -r 'first(.[] | select(.label == "cf")).id // empty')

      if [ -z "$tag_id" ]; then
        tag=$(
          curl "''${curl_args[@]}" \
            --request POST \
            --header 'Content-Type: application/json' \
            --data '{"label":"cf"}' \
            "$prowlarr_api/tag"
        )
        tag_id=$(printf '%s' "$tag" | jq -r '.id // empty')
      fi

      if [ -z "$tag_id" ]; then
        echo "Prowlarr did not return an ID for the cf tag" >&2
        exit 1
      fi

      payload=$(
        printf '%s' "$proxy" | jq -c \
          --arg host "$flaresolverr_url" \
          --argjson tag_id "$tag_id" '
            def set_field($name; $value):
              .fields |= map(if .name == $name then .value = $value else . end);

            .name = "FlareSolverr"
            | .tags = [$tag_id]
            | set_field("host"; $host)
          '
      )

      proxy_id=$(printf '%s' "$proxy" | jq -r '.id // empty')
      if [ -n "$proxy_id" ] && [ "$proxy_id" != "0" ]; then
        curl "''${curl_args[@]}" \
          --request PUT \
          --header 'Content-Type: application/json' \
          --data "$payload" \
          --output /dev/null \
          "$prowlarr_api/indexerProxy/$proxy_id"
      else
        payload=$(printf '%s' "$payload" | jq -c 'del(.id)')
        curl "''${curl_args[@]}" \
          --request POST \
          --header 'Content-Type: application/json' \
          --data "$payload" \
          --output /dev/null \
          "$prowlarr_api/indexerProxy"
      fi

      curl "''${curl_args[@]}" "$prowlarr_api/indexerProxy" \
        | jq --exit-status \
          --raw-output \
          --arg host "$flaresolverr_url" \
          --argjson tag_id "$tag_id" '
            (
              first(.[] | select(
                .name == "FlareSolverr"
                and any(.tags[]; . == $tag_id)
                and any(.fields[]; .name == "host" and .value == $host)
              ))
              // error("Prowlarr did not retain the FlareSolverr proxy configuration")
            )
            | "Configured \(.implementation) at \($host) with the cf tag"
          '
    '';
  };
  mediaServices = [
    "jellyfin"
    "sonarr"
    "sonarr-sync-config"
    "radarr"
    "radarr-sync-config"
    "prowlarr"
    "prowlarr-sync-config"
    "prowlarr-flaresolverr-sync"
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
        qui.enable = true;
      };

      vpn = {
        enable = true;
        wgConf = "/run/agenix/mullvad-wg";
        exposeOnLAN = false;
        proxyListenAddr = "127.0.0.1";
      };

      recyclarr = {
        enable = true;
        configuration = {
          radarr.movies = {
            base_url = "http://127.0.0.1:7878";
            api_key = "!env_var RADARR_API_KEY";

            delete_old_custom_formats = true;

            quality_definition.type = "movie";

            quality_profiles = [
              {
                trash_id = "fd161a61e3ab826d3a22d53f935696dd";
                reset_unmatched_scores.enabled = true;
              }
            ];
          };

          sonarr.series = {
            base_url = "http://127.0.0.1:8989";
            api_key = "!env_var SONARR_API_KEY";

            delete_old_custom_formats = true;

            quality_definition.type = "series";

            quality_profiles = [
              {
                trash_id = "76a5053bdb2d1e4a8f16a69a37d46c12";
                reset_unmatched_scores.enabled = true;
              }
            ];
          };
        };
      };

      exporters.enable = true;
    };

    services.flaresolverr = {
      enable = true;
      port = flaresolverrPort;
      openFirewall = false;
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

    systemd.services = lib.mkMerge [
      (lib.genAttrs mediaServices (_: {
        unitConfig.RequiresMountsFor = [mediaDir stateDir];
      }))
      {
        flaresolverr.environment = {
          HOST = "127.0.0.1";
          LOG_LEVEL = "info";
        };
        wg.restartTriggers = [config.age.secrets.mullvad-wg.file];
        nginx = {
          after = ["wg.service"];
          wants = ["wg.service"];
        };
        qbittorrent.unitConfig.PartOf = ["wg.service"];
        prowlarr-flaresolverr-sync = {
          description = "Configure FlareSolverr as a Prowlarr indexer proxy";
          after = [
            "flaresolverr.service"
            "prowlarr-api.service"
          ];
          requires = [
            "flaresolverr.service"
            "prowlarr-api.service"
          ];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            User = "prowlarr";
            Group = "prowlarr";
            ExecStart = lib.getExe syncProwlarrFlareSolverr;
            RemainAfterExit = true;
          };
        };
      }
    ];
  };
}
