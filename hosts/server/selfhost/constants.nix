let
  internalDomain = "lan.vmohammad.dev";

  servicePorts = {
    home = 8081;
    media = 8096;
    sonarr = 8989;
    radarr = 7878;
    prowlarr = 9696;
    bazarr = 6767;
    seerr = 5055;
    qui = 5252;
    grafana = 3001;
    prometheus = 9090;
  };
in {
  serverIp = "192.168.1.31";
  virtualIp = "192.168.1.200";
  interface = "eno2";

  inherit internalDomain;

  myServices = builtins.listToAttrs (
    map (name: {
      name = "${name}.${internalDomain}";
      value = servicePorts.${name};
    }) (builtins.attrNames servicePorts)
  );

  proxiedDevices = ["192.168.1.53"];

  proxiedDomains = [
    "tiktok.com"
    "tiktokv.com"
    "tiktokcdn.com"
    "tiktokcdn-eu.com"
    "tiktokw.eu"
    "byteoversea.com"
    "ibyteimg.com"
    "ibytedtos.com"
    "musical.ly"
    "mullvad.net"
  ];
}
