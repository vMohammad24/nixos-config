{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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
  services.udisks2.enable = true;
}
