{
  pkgs,
  inputs,
  ...
}: {
  services.getty.autologinUser = "vmohammad";
  users.users.vmohammad = {
    isNormalUser = true;
    extraGroups = ["wheel" "gamemode" "libvirtd"];
    packages = with pkgs; [
      vscode
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
    fastfetch
    libsecret
    btop
    p7zip
    fzf
    fd
    inputs.alejandra.defaultPackage.${pkgs.system}
    inputs.tidaLuna.packages.${pkgs.system}.default
    inputs.grabit.packages.${pkgs.system}.default
    inputs.wl-mouse.packages.${pkgs.system}.default
    prismlauncher
    mullvad-vpn
    watchexec
  ];

  nixpkgs.overlays = [
    inputs.tidaLuna.overlays.default
  ];
}
