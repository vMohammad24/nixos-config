{
  lib,
  pkgs,
  ...
}: let
  virtualIp = "192.168.1.200";

  proxiedDomains = [
    "tiktok.com"
    "tiktokv.com"
    "tiktokcdn.com"
    "byteoversea.com"
    "mullvad.net"
  ];
in {
  systemd.services.nginx-vpn-proxy = {
    description = "Nginx stream proxy confined to wg VPN namespace";
    after = ["wg.service" "network-online.target"];
    wants = ["wg.service" "network-online.target"];
    wantedBy = ["multi-user.target"];

    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    preStart = ''
      if ! ${pkgs.iptables}/bin/iptables -C INPUT -p tcp --dport 443 -j ACCEPT -i veth-wg 2>/dev/null; then
        ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT -i veth-wg
      fi
    '';

    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.nginx}/bin/nginx -c /etc/nginx-vpn-proxy.conf -g 'daemon off;'";
      ExecReload = "${pkgs.nginx}/bin/nginx -c /etc/nginx-vpn-proxy.conf -s reload";
      Restart = "always";
    };
  };

  environment.etc."nginx-vpn-proxy.conf".text = let
    mapEntries = lib.concatStringsSep "\n" (map (domain: ".${domain}      $ssl_preread_server_name;") proxiedDomains);
  in ''
    error_log syslog:server=unix:/dev/log notice;

    events {
      worker_connections 1024;
    }

    stream {
      resolver 10.64.0.1 valid=300s;

      map $ssl_preread_server_name $upstream {
        hostnames;
        ${mapEntries}
      }

      server {
        listen 192.168.15.1:443;
        ssl_preread on;
        proxy_pass $upstream:443;
        proxy_connect_timeout 10s;
        proxy_timeout 30s;
      }
    }
  '';

  services.dnsmasq.settings.address = map (domain: "/${domain}/${virtualIp}") proxiedDomains;
}
