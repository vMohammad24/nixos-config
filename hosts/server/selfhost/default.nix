{lib, ...}: let
  inherit (import ./constants.nix) serverIp virtualIp interface internalDomain myServices;
in {
  imports = [
    ./projects.nix
    ./status.nix
    ./glance.nix
    ./media.nix
    ./monitoring.nix
    ./netbird.nix
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
      "b6180c38-8f39-4f1a-a115-ca4e29e9ca04" = {
        credentialsFile = "/run/agenix/cloudflared-atums";
        ingress."status.atums.world" = "http://127.0.0.1:3032";
        default = "http_status:503";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "vmohammad@vmohammad.dev";
    certs.${internalDomain} = {
      domain = internalDomain;
      extraDomainNames = ["*.${internalDomain}"];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles."CF_DNS_API_TOKEN_FILE" = "/run/agenix/cloudflare-dns-api-token";
      group = "nginx";
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
      lib.mapAttrs (domain: port: {
        useACMEHost = internalDomain;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      })
      myServices;
  };
}
