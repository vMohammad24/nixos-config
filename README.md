# NixOS Configuration

my personal nixos config utilizing flakes & home-manager

## features

- **WM**: [hyprland](https://hyprland.org/)
- **theme**: rose pine via [stylix](https://github.com/danth/stylix)
- **formatting**: [alejandra](https://github.com/kamadorueda/alejandra)

## file structure

- `flake.nix`: main flake.
- `configuration.nix`: system config.
- `home.nix`: main home manager config.
- `modules/`:
  - `system/`: system-wide modules.
  - `home/`: home manager config (shell, programs, window managers).
  - `stylix.nix`: themeing config.

## installation

1. **clone**:
   ```bash
   git clone https://github.com/vMohammad24/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   ```

2. **apply your hardware-configuration.nix**:
   
alot of stuff in this project is hardware-specfic, so you should generate a `hardware-configuration.nix` using the [nixos-generate](https://nixos.wiki/wiki/Nixos-generate-config) tool and place it in the root of the project.

modify `/modules/system/hardware.nix` to match your system.

3. **build and switch**:
   ```bash
   nixos-rebuild switch --flake .#hyprland
   ```
