{...}: {
  imports = [
    ./isDesktop.nix
    ./core.nix
    ./hardware.nix
    ./desktop.nix
    ./services.nix
    ./users.nix
  ];
}
