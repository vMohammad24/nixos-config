{pkgs, ...}: {
  imports = [
    ./forgejo-runner.nix
  ];
  networking.firewall.allowedTCPPorts = [3300 3301]; # so docker can access the cache
  services.forgejo-runner = {
    enable = true;

    hostPackages = with pkgs; [
      bash
      coreutils
      curl
      gawk
      gitMinimal
      gnused
      nodejs
      wget
      nix
      jq
      gnutar
      zstd
    ];

    settings = {
      log = {
        level = "info";
        job_level = "info";
      };

      runner = {
        capacity = 2;
        timeout = "3h";
      };

      cache = {
        enabled = true;
        host = "192.168.1.31";
        port = 3300;
        proxy_port = 3301;
      };

      server = {
        connections = {
          heliopolis = {
            url = "https://heliopolis.live/";
            token_url = "file:///run/agenix/heliopolis-runner-token";
            uuid = "6c3af0fb-c67e-410d-af39-a3cfb7d33dbf";
            labels = [
              "vmo-host:host"
              "vmo-ubuntu:docker://node:26-bullseye"
            ];
          };
        };
      };
    };
  };
}
