{lib, ...}: let
  serverIp = "192.168.1.31";

  myServices = {
    "home.local" = 8081;
    "media.local" = 8096;
    "sonarr.local" = 8989;
    "radarr.local" = 7878;
    "prowlarr.local" = 9696;
    "bazarr.local" = 6767;
    "seerr.local" = 5055;
    "qui.local" = 5252;
    "grafana.local" = 3001;
    "prometheus.local" = 9090;
  };
in {
  imports = [
    ./projects.nix
    ./glance.nix
    ./media.nix
    ./monitoring.nix
    ./forgejo
  ];
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
    };
    dbBackend = "sqlite";
    domain = "vw.vmohammad.dev";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "3d9a81e9-9dab-43a5-b910-2240006a90dc" = {
        credentialsFile = "/run/agenix/cloudflared";

        "warp-routing" = {
          enabled = true;
        };

        ingress = {
          "dev.vmohammad.dev" = "http://192.168.1.30:3000";
          "vw.vmohammad.dev" = "http://127.0.0.1:8222";
          "tidal.vmohammad.dev" = "http://127.0.0.1:3000";
        };
        default = "http_status:503";
      };
    };
  };

  services.pihole-ftl = {
    enable = true;
    privacyLevel = 3;

    settings = {
      dns = {
        upstreams = ["1.1.1.1" "1.0.0.1"];
        queryLogging = false;
        ignoreLocalhost = true;
        hosts = lib.mapAttrsToList (domain: port: "${serverIp} ${domain}") myServices;
      };

      database.maxDBdays = 0;
      misc.extraLogging = false;
      webserver.api.cli_pw = true;
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Pro";
      }
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Threat Intelligence Feed";
      }
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/whitelist-referral.txt";
        type = "allow";
        enabled = true;
        description = "HaGeZi referral allowlist";
      }
      {
        url = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt";
        type = "block";
        enabled = true;
        description = "WindowsSpyBlocker";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = ["127.0.0.1:8080"];
  };

  services.nginx = {
    enable = true;

    virtualHosts =
      lib.mapAttrs (domain: port: {
        locations."/" = {
          proxyPass = "http://${serverIp}:${toString port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
          '';
        };
      })
      myServices;
  };
}
