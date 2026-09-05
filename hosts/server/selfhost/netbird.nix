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
}
