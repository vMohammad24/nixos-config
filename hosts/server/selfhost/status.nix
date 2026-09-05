{lib, ...}: let
  statusDomain = "status.atums.world";
  webPort = 3030;
  apiPort = 3031;
  proxyPort = 3032;
in {
  services.postgresql = {
    ensureDatabases = ["status"];
    ensureUsers = [
      {
        name = "status";
        ensureDBOwnership = true;
      }
    ];

    authentication = lib.mkBefore ''
      host status status 127.0.0.1/32 trust
    '';
  };

  virtualisation.podman.enable = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers.status = {
      image = "registry.heliopolis.live/atums/status@sha256:e8c36e259f8e123ce50f9feb3fe4c1bdd930118e18cf3b8000e5549e57fa0523";
      autoStart = true;
      extraOptions = [
        "--network=host"
        "--no-healthcheck"
      ];
      environment = {
        DATABASE_URL = "postgres://status@127.0.0.1:5432/status";

        API_HOST = "127.0.0.1";
        API_PORT = toString apiPort;
        API_BASE_PATH = "/api";
        API_INTERNAL_URL = "http://127.0.0.1:${toString apiPort}/api";

        HOST = "127.0.0.1";
        PORT = toString webPort;

        PUBLIC_TIMEZONE = "Asia/Amman";
        PUBLIC_API_URL = "https://${statusDomain}/api";
      };
    };
  };

  systemd.services.podman-status = {
    after = ["postgresql.service"];
    requires = ["postgresql.service"];
  };

  services.nginx.virtualHosts.${statusDomain} = {
    listen = [
      {
        addr = "127.0.0.1";
        port = proxyPort;
      }
    ];
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString webPort}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
      "/api" = {
        proxyPass = "http://127.0.0.1:${toString apiPort}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
