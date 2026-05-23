{...}: {
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
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
          "dev.vmohammad.dev" = "http://192.168.0.148:3000";
          "vw.vmohammad.dev" = "http://127.0.0.1:8222";
        };
        default = "http_status:503";
      };
    };
  };

  services.pihole-ftl = {
    enable = true;
    settings = {
      dns.upstreams = ["1.1.1.1" "1.0.0.1"];
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "StevenBlack blocklist";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = ["443s"];
  };
}
