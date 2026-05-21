{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  services.getty.autologinUser = lib.mkIf (!config.myConfig.desktops.kde.enable) "vmohammad";
  nix.settings.trusted-users = ["root" "vmohammad"];
  users.users.vmohammad = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [
      "wheel"
      "gamemode"
      "libvirtd"
      "docker"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ5pU3r+Ne1Tc/w4mf0z6J2VjZPj1aQ9eFvVUAPJHmc9CRL8IbcD06DwoCYkA7uYzgSdOZ/1wjGhtyJrNPsewEXcW1ORdsjeZFrtW0NEuasGzG/grYIVzWG2GwIajI+5871OPcKSRmm6oewRJBIiJ0zqq90CL1pXN21doPwyl4M4ib5SPKK7rn5up5uIYDyN5p2tnNf1QhNJPaNT1EcCX3GZJQfkCAx6CK40MkYkc35kW2nfyrv3fviSvUnyWSKrxg2iuSLgHSCu6oNo8K7iwwPNoUVa3CC4wi8yQ3UMpCC5qzDPxHdWgvIuU4CfNKKY43XZ7S0mZn4CPjRNzvJvmuPZDmeen6vme0QQi6YEcSS1imrrmiPEMT3xCZFPkineExfcDd+KArd5mjrStclt1YZITTVN75GMMXfrj0W/jt42A0YzoMb6b1VWx1nlFObXPj40Fx9qAvqG7bElpnIrbZGafAXnJELV6T2GfLPhmYh4dPm/Y2BrOZXGvYORBHbJE= vmohammad@DESKTOP-5AQM705"
    ];
  };

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
  };
  programs.localsend.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip
    git
    libsecret
    # change this if you have an AMD GPU (btop-rocm)
    btop-cuda
    p7zip
    fzf
    fd
    killall
    inputs.alejandra.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.wl-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # i am not proud of this part
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];
}
