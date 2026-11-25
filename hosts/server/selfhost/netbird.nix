{config, ...}: let
  client = config.services.netbird.clients.server;
  managementHost = "netbird.creations.works:443";
  managementUrl = "https://${managementHost}";
in {
  services.netbird.useRoutingFeatures = "server";

  services.netbird.clients.server = {
    port = 51820;
    interface = "netbird0";
    environment.NB_MANAGEMENT_URL = managementUrl;
    config.ManagementURL = {
      Scheme = "https";
      Host = managementHost;
      Path = "/";
    };
    config.DisableDNS = true;
    config.ServerSSHAllowed = false;
    login = {
      enable = true;
      setupKeyFile = "/run/agenix/netbird-setup-key";
    };
  };

  users.users.vmohammad.extraGroups = [client.user.group];

  networking.firewall.interfaces.netbird0.allowedTCPPorts = [
    2583
    2584
    2222
  ];

  systemd.services.netbird-server-login.serviceConfig.TimeoutStartSec = "90s";
}
