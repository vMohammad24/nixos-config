{
  serverIp = "192.168.1.31";
  virtualIp = "192.168.1.200";
  interface = "eno2";

  myServices = {
    "home.local" = 8081;
    "media.local" = 8096;
    "sonarr.local" = 8989;
    "radarr.local" = 7878;
    "prowlarr.local" = 9696;
    "bazarr.local" = 6767;
    "seerr.local" = 5055;
    "qui.local" = 5252;
    "grafana.local" = 3001;
    "prometheus.local" = 9090;
  };

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
