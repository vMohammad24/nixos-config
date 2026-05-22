{
  config,
  pkgs,
  lib,
  ...
}: let
  isDesktop = config.myConfig.isDesktop;
in {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.pipewire = lib.mkIf isDesktop {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    # remove this if your DAC doesn't support 192kHz, run this to find out: `cat /proc/asound/card1/stream0 | grep Rates`
    extraConfig.pipewire = {
      "99-schiit-rates" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
        };
      };
    };
  };

  services.sunshine = lib.mkIf isDesktop {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.wivrn = lib.mkIf isDesktop {
    enable = true;
    openFirewall = true;
    autoStart = true;
    package = pkgs.wivrn.override {cudaSupport = true;};
  };

  services.gnome.gnome-keyring.enable = isDesktop;
  services.gvfs.enable = isDesktop;
  services.gnome.tinysparql.enable = isDesktop;
  services.gnome.localsearch.enable = isDesktop;
  services.udisks2.enable = lib.mkForce isDesktop;
  services.devmon.enable = isDesktop;
  services.mullvad-vpn.enable = isDesktop;
  services.mullvad-vpn.package = lib.mkIf isDesktop pkgs.mullvad-vpn;
}
