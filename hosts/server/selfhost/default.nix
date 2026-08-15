{
  lib,
  pkgs,
  ...
}: let
  inherit (import ./constants.nix) serverIp virtualIp interface myServices;

  tlsCert = pkgs.runCommand "local-selfsigned-cert" {buildInputs = [pkgs.openssl];} ''
    mkdir -p $out
    openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:P-256 \
      -keyout $out/key.pem -out $out/cert.pem \
      -days 3650 -nodes -subj "/CN=*.local" \
      -addext "subjectAltName=DNS:*.local"
  '';
in {
  imports = [
    ./projects.nix
    ./glance.nix
    ./media.nix
    ./monitoring.nix
    ./proxy.nix
    ./unbound.nix
    ./forgejo
  ];

  networking.interfaces.${interface} = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = serverIp;
        prefixLength = 24;
      }
      {
        address = virtualIp;
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = "192.168.1.1";

  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/run/agenix/mullvad-wg";
    accessibleFrom = ["192.168.1.0/24"];
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
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

  services.speedtest-tracker = {
    enable = true;
    enableNginx = true;
    virtualHost = "speedtest.local";
    settings = {
      APP_KEY_FILE = "/run/agenix/speedtest-tracker-key";
      APP_URL = "https://speedtest.local";
    };
  };

  services.nginx = {
    enable = true;
    defaultListenAddresses = [serverIp "127.0.0.1"];

    streamConfig = ''
      server {
        listen ${virtualIp}:443;
        proxy_pass 192.168.15.1:443;
      }
      server {
        listen ${virtualIp}:80;
        proxy_pass 192.168.15.1:80;
      }
    '';

    virtualHosts =
      (lib.mapAttrs (domain: port: {
          sslCertificate = "${tlsCert}/cert.pem";
          sslCertificateKey = "${tlsCert}/key.pem";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            extraConfig = ''
              proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
            '';
          };
        })
        myServices)
      // {
        "speedtest.local" = {
          sslCertificate = "${tlsCert}/cert.pem";
          sslCertificateKey = "${tlsCert}/key.pem";
          forceSSL = true;
        };
      };
  };
}
