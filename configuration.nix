{
  config,
  lib,
  pkgs,
  alejandra,
  tidaLuna,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  time.timeZone = "Asia/Amman";
  services.xserver.videoDrivers = ["nvidia"];
  services.getty.autologinUser = "vmohammad";
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  services.gnome.gnome-keyring.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  users.users.vmohammad = {
    isNormalUser = true;
    extraGroups = ["wheel" "gamemode"];
    packages = with pkgs; [
      tree
      vscode
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    kitty
    foot
    curl
    unzip
    git
    zed-editor
    helix
    fastfetch
    libsecret
    hyprpolkitagent
    protonup-rs
    mangohud
    btop
    p7zip
    wayland-utils
    glib
    zoxide
    fzf
    fd
    nodejs_24
    bun
    direnv
    nix-direnv
    glib-networking
    alejandra.defaultPackage.${pkgs.system}
    tidaLuna.packages.${pkgs.system}.default
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-lgc-plus
    ibm-plex
    amiri
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];

    config.common.default = ["*"];
  };
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    GIO_EXTRA_MODULES = ["${pkgs.glib-networking}/lib/gio/modules"];
    # NVIDIA <3
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    EGL_PLATFORM = "wayland";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    WLR_DRM_NO_ATOMIC = "1";
    RADV_PERFTEST = "gpl";
  };

  nixpkgs.overlays = [
    tidaLuna.overlays.default
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
