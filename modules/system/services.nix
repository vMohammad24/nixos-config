{pkgs, ...}: {
  services.pipewire = {
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

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = true;
    autoStart = true;
    package = pkgs.wivrn.override {cudaSupport = true;};
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.gnome.tinysparql.enable = true;
  services.gnome.localsearch.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
