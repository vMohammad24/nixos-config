{
  pkgs,
  inputs,
  ...
}: {
  services.getty.autologinUser = "vmohammad";
  users.users.vmohammad = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gamemode"
      "libvirtd"
      "docker"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
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
    btop
    p7zip
    fzf
    fd
    inputs.alejandra.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.grabit.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.wl-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
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
