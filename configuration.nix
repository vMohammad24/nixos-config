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
    ./modules/system
  ];
}
