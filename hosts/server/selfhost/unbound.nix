{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./constants.nix) serverIp virtualIp myServices proxiedDomains;

  blocklist = pkgs.runCommand "unbound-blocklist.conf" {nativeBuildInputs = [pkgs.gawk];} ''
    awk '
      /^\|\|[[:alnum:]_.-]+\^$/ {
        domain = substr($0, 3, length($0) - 3)
        print tolower(domain)
      }
      $1 ~ /^(0\.0\.0\.0|127\.0\.0\.1)$/ && $2 ~ /^[[:alnum:]_.-]+$/ {
        print tolower($2)
      }
    ' ${inputs.hagezi-pro} \
      ${inputs.hagezi-tif} \
      ${inputs.windows-spy-blocker-hosts} \
      | sort -u >blocked

    awk '
      /^@@\|\|[[:alnum:]_.-]+\^/ {
        domain = substr($0, 5)
        sub(/\^.*/, "", domain)
        print tolower(domain)
      }
    ' ${inputs.hagezi-whitelist-referral} | sort -u >allowed

    if [ "$(wc -l <blocked)" -lt 100000 ]; then
      echo "Refusing to build an unexpectedly small Unbound blocklist" >&2
      exit 1
    fi

    comm -23 blocked allowed \
      | awk '{ printf "local-zone: \"%s.\" always_nxdomain\n", $0 }' >$out
    awk '{ printf "local-zone: \"%s.\" transparent\n", $0 }' allowed >>$out
  '';
in {
  networking.nameservers = ["127.0.0.1"];
  networking.firewall = {
    allowedTCPPorts = [53 80 443];
    allowedUDPPorts = [53];
  };

  services.unbound = {
    enable = true;
    checkconf = true;
    settings = {
      server = {
        interface = ["127.0.0.1" serverIp];
        access-control = [
          "127.0.0.0/8 allow"
          "192.168.1.0/24 allow"
        ];
        local-zone =
          [''"local." static'']
          ++ map (domain: ''"${domain}." redirect'') proxiedDomains;
        local-data =
          lib.mapAttrsToList (domain: _: ''"${domain}. IN A ${serverIp}"'') myServices
          ++ map (domain: ''"${domain}. IN A ${virtualIp}"'') proxiedDomains;
        include = "${blocklist}";
        hide-identity = true;
        hide-version = true;
        prefetch = true;
        qname-minimisation = true;
        serve-expired = true;
        serve-expired-client-timeout = 0;
        serve-expired-ttl = 86400;
      };
    };
  };
}
