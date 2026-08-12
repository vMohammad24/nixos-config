{
  lib,
  pkgs,
  ...
}: let
  interface = "eno2";
  virtualIp = "192.168.1.200";
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

  proxiedDeviceSet = lib.concatStringsSep ", " proxiedDevices;
in {
  networking.firewall.filterForward = true;
  networking.nat = {
    enable = true;
    externalInterface = interface;
    internalIPs = ["192.168.1.0/24"];
  };

  networking.nftables.tables = lib.mkIf (proxiedDevices != []) {
    sniproxy = {
      family = "ip";
      content = ''
        set proxied_devices {
          type ipv4_addr
          flags interval
          elements = { ${proxiedDeviceSet} }
        }

        chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;

          iifname "${interface}" ip saddr @proxied_devices tcp dport 443 dnat to ${virtualIp}:443
        }

        chain forward {
          type filter hook forward priority filter; policy accept;

          iifname "${interface}" ip saddr @proxied_devices udp dport 443 reject with icmp type admin-prohibited
        }
      '';
    };
  };

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
        default $ssl_preread_server_name;
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

  services.dnsmasq.settings.address =
    (map (domain: "/${domain}/${virtualIp}") proxiedDomains)
    ++ (map (domain: "/*.${domain}/${virtualIp}") proxiedDomains);

  services.dnsmasq.settings.cname =
    (map (domain: "*.${domain},${domain}") proxiedDomains)
    ++ ["www.tiktok.com,tiktok.com"];
}
