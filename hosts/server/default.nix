{...}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  networking.hostName = "server";
  services.upower.ignoreLid = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  users.users.vmohammad.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ5pU3r+Ne1Tc/w4mf0z6J2VjZPj1aQ9eFvVUAPJHmc9CRL8IbcD06DwoCYkA7uYzgSdOZ/1wjGhtyJrNPsewEXcW1ORdsjeZFrtW0NEuasGzG/grYIVzWG2GwIajI+5871OPcKSRmm6oewRJBIiJ0zqq90CL1pXN21doPwyl4M4ib5SPKK7rn5up5uIYDyN5p2tnNf1QhNJPaNT1EcCX3GZJQfkCAx6CK40MkYkc35kW2nfyrv3fviSvUnyWSKrxg2iuSLgHSCu6oNo8K7iwwPNoUVa3CC4wi8yQ3UMpCC5qzDPxHdWgvIuU4CfNKKY43XZ7S0mZn4CPjRNzvJvmuPZDmeen6vme0QQi6YEcSS1imrrmiPEMT3xCZFPkineExfcDd+KArd5mjrStclt1YZITTVN75GMMXfrj0W/jt42A0YzoMb6b1VWx1nlFObXPj40Fx9qAvqG7bElpnIrbZGafAXnJELV6T2GfLPhmYh4dPm/Y2BrOZXGvYORBHbJE= vmohammad@DESKTOP-5AQM705"
  ];
}
