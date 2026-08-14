{
  config,
  lib,
  pkgs,
  ...
}: let
  grafanaPort = 3001;
  promPort = 9090;
  alertmanagerPort = 9093;

  scrape = job: port: {
    job_name = job;
    static_configs = [{targets = ["127.0.0.1:${toString port}"];}];
  };
in {
  options.myConfig.monitoring.enable = lib.mkEnableOption "Prometheus and Grafana monitoring";

  config = lib.mkIf config.myConfig.monitoring.enable {
    services.prometheus.exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      enabledCollectors = ["rapl"];
    };
    services.prometheus.exporters.systemd.enable = true;
    services.prometheus.exporters.wireguard.enable = true;
    services.prometheus.exporters.smartctl = {
      enable = true;
      listenAddress = "127.0.0.1";
    };

    services.smartd = {
      enable = true;
      autodetect = true;
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="powercap", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp node-exporter /sys/%p/energy_uj", RUN+="${pkgs.coreutils}/bin/chmod 0440 /sys/%p/energy_uj"
    '';

    boot.kernelModules = ["intel_rapl_common"];

    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = promPort;
      retentionTime = "30d";
      ruleFiles = [./alerts.yml];
      alertmanagers = [
        {
          static_configs = [{targets = ["127.0.0.1:${toString alertmanagerPort}"];}];
        }
      ];

      scrapeConfigs =
        [
          (scrape "node" 9100)
          (scrape "systemd" 9558)
          (scrape "wireguard" 9586)
          (scrape "smartctl" 9633)
          (scrape "prometheus" promPort)
          (scrape "alertmanager" alertmanagerPort)
        ]
        ++ lib.optionals config.myConfig.rr.enable [
          (scrape "sonarr" 9707)
          (scrape "radarr" 9708)
          (scrape "prowlarr" 9711)
          (scrape "qbittorrent" 9713)
        ];
    };

    services.prometheus.alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = alertmanagerPort;
      environmentFile = config.age.secrets.alertmanager-discord-env.path;
      checkConfig = false;
      configuration = {
        route = {
          receiver = "discord";
          group_by = ["alertname"];
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "4h";
        };
        receivers = [
          {
            name = "discord";
            discord_configs = [
              {
                webhook_url = "$DISCORD_WEBHOOK_URL";
                send_resolved = true;
                title = "{{ .Status | toUpper }}: {{ .CommonLabels.alertname }}";
                message = "{{ range .Alerts }}**{{ .Annotations.summary }}**\n{{ .Annotations.description }}{{ end }}";
              }
            ];
          }
        ];
      };
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
