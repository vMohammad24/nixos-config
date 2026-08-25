# NixOS Configuration

my personal nixos config utilizing flakes & home-manager

## features

- **hosts**: main-desktop (gaming/dev) and server (self-hosted services)
- **WM/DE**: [hyprland](https://hyprland.org/) by default, with mango and niri boot specialisations
- **theme**: rose pine via [stylix](https://github.com/nix-community/stylix)
- **secrets**: managed via [agenix](https://github.com/ryantm/agenix)
- **formatting**: [alejandra](https://github.com/kamadorueda/alejandra)
- **monitoring**: prometheus, alertmanager, grafana, loki, and alloy validation through flake checks

## file structure

- `flake.nix`: main flake.
- `hosts/`: machine-specific configs and hardware settings.
- `users/`: user-specific entrypoints.
- `secrets/`: encrypted agenix keys.
- `modules/`:
  - `system/`: system-wide modules (core, hardware, users).
  - `home/`: home manager config (shell, dev, programs, window managers).
  - `desktops/`: base configurations for hyprland, mango and niri.
  - `stylix.nix`: themeing config.

## installation

1. **clone**:
   ```bash
   git clone https://github.com/vMohammad24/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   ```

2. **apply your hardware-configuration.nix**:

alot of stuff in this project is hardware-specfic, so you should generate a `hardware-configuration.nix` using the [nixos-generate](https://nixos.wiki/wiki/Nixos-generate-config) tool and place it in the `hosts/(main-desktop/server)` directory of the project.


review `modules/system/hardware.nix` and each enabled compositor's monitor file.
make sure the host SSH key is authorized to decrypt its agenix secrets.

3. **build and switch**:
   ```bash
   sudo nixos-rebuild switch --flake .#main-desktop
   sudo nixos-rebuild switch --flake .#server
   ```

The `mango` and `niri` boot specialisations are included in the main desktop
generation.

## validation

Run these commands from the repository root before switching:

```bash
nix fmt
nix flake check
```
