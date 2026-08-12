{
  config,
  lib,
  ...
}: let
  grafanaPort = 3001;
  promPort = 9090;

  scrape = job: port: {
    job_name = job;
    static_configs = [{targets = ["127.0.0.1:${toString port}"];}];
  };
in {
  options.myConfig.monitoring.enable = lib.mkEnableOption "Prometheus and Grafana monitoring";

  config = lib.mkIf config.myConfig.monitoring.enable {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = promPort;
      retentionTime = "30d";

      scrapeConfigs = [
        (scrape "node" 9100)
        (scrape "systemd" 9558)
        (scrape "sonarr" 9707)
        (scrape "radarr" 9708)
        (scrape "prowlarr" 9711)
        (scrape "qbittorrent" 9713)
        (scrape "wireguard" 9586)
        (scrape "prometheus" promPort)
      ];
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = grafanaPort;
          domain = "grafana.local";
          root_url = "https://grafana.local/";
        };
        security.secret_key = "$__file{/run/agenix/grafana-secret-key}";
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString promPort}";
            isDefault = true;
          }
        ];
        dashboards.settings.providers = [
          {
            name = "nixarr";
            options.path = ./dashboards;
          }
        ];
      };
    };
  };
}
