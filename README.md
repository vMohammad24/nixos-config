# NixOS Configuration

my personal nixos config utilizing flakes & home-manager

## features

- **hosts**: main-desktop (gaming/dev) and server (self-hosted services)
- **WM/DE**: [hyprland](https://hyprland.org/), [mango](https://mangowm.github.io/) and [plasma](https://kde.org/) via boot specialisations
- **theme**: rose pine via [stylix](https://github.com/nix-community/stylix)
- **secrets**: managed via [agenix](https://github.com/ryantm/agenix)
- **formatting**: [alejandra](https://github.com/kamadorueda/alejandra)

## file structure

- `flake.nix`: main flake.
- `hosts/`: machine-specific configs and hardware settings.
- `users/`: user-specific entrypoints.
- `secrets/`: encrypted agenix keys.
- `modules/`:
  - `system/`: system-wide modules (core, hardware, users).
  - `home/`: home manager config (shell, dev, programs, window managers).
  - `desktops/`: base configurations for hyprland, kde, and mango.
  - `stylix.nix`: themeing config.

## installation

1. **clone**:
   ```bash
   git clone https://github.com/vMohammad24/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   ```

2. **apply your hardware-configuration.nix**:

alot of stuff in this project is hardware-specfic, so you should generate a `hardware-configuration.nix` using the [nixos-generate](https://nixos.wiki/wiki/Nixos-generate-config) tool and place it in the `hosts/(main-desktop/server)` directory of the project.


modify `/modules/system/hardware.nix` and `modules/home/windowManager/(hyprland/mango)/monitors.nix` to match your system. make sure your ssh keys are set up to decrypt agenix secrets.

3. **build and switch**:
   ```bash
   sudo nixos-rebuild switch --flake .#(main-desktop/server)
   ```
