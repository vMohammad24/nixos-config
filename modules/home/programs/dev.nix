{
  pkgs,
  lib,
  inputs,
  ...
}: let
  biomeFmt = {formatter.language_server.name = "biome";};
  hostName = "main-desktop";
  biomeWithActions =
    biomeFmt
    // {
      code_actions_on_format = {
        "source.fixAll.biome" = true;
        "source.organizeImports.biome" = true;
      };
    };
in {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "vMohammad";
        email = "git@vmohammad.dev";
        signingkey = "2BCEA4D1380380B8";
      };
      init.defaultBranch = "main";
      commit.gpgsign = true;
      tag.gpgSign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
    };
    includes = [
      {
        condition = "hasconfig:remote.*.url:https://github.com/**";
        contents.user.name = "vMohammad24";
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents.user.name = "vMohammad24";
      }
    ];
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      ols
      biome
      rust-analyzer
      rustfmt
      clippy
      clang-tools
      lldb
      delve
      vscode-extensions.vadimcn.vscode-lldb
    ];
    extensions = [
      "biome"
      "dockerfile"
      "ini"
      "rainbow-csv"
      "svelte"
      "html"
      "nix"
      "toml"
      "zig"
      "odin"
      "sql"
      "qml"
      "make"
      "neocmake"
    ];
    userSettings = {
      disable_ai = true;
      cli_default_open_behavior = "new_window";
      load_direnv = "shell_hook";
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      session = {
        trust_all_worktrees = true;
      };
      auto_update = false;
      project_panel = {
        hide_gitignore = true;
        dock = "right";
      };
      lsp = {
        biome = {
          settings = {
            require_config_file = true;
            inline_config = {
              vcs = {
                enabled = false;
                clientKind = "git";
                useIgnoreFile = false;
              };
              files = {
                ignoreUnknown = false;
                ignore = [];
              };
              formatter = {
                enabled = true;
                indentStyle = "tab";
              };
              organizeImports = {
                enabled = true;
              };
              linter = {
                enabled = true;
                rules = {
                  recommended = true;
                  style = {
                    noNonNullAssertion = "off";
                  };
                  suspicious = {
                    noExplicitAny = "off";
                  };
                };
              };
              javascript = {
                formatter = {
                  quoteStyle = "double";
                };
              };
            };
          };
        };
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings = {
            nixpkgs.expr = "(builtins.getFlake (builtins.toString ${inputs.self})).inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}";
            options = {
              nixos.expr = "(builtins.getFlake (builtins.toString ${inputs.self})).nixosConfigurations.${hostName}.options";
              home-manager.expr = "(builtins.getFlake (builtins.toString ${inputs.self})).nixosConfigurations.${hostName}.options.home-manager.users.type.getSubOptions [ ]";
            };
          };
        };
      };
      languages = {
        Astro = biomeFmt;
        CSS = biomeFmt;
        GraphQL = biomeFmt;
        HTML = biomeFmt;
        JSON = biomeFmt;
        JSONC = biomeFmt;
        JSX = biomeFmt;
        JavaScript = biomeWithActions;
        TypeScript = biomeWithActions;
        TSX = biomeWithActions;
        "Vue.js" = biomeFmt;
        Svelte = {language_servers = ["!biome" "..."];};
        "Nix" = {
          formatter = {
            external = {
              command = "alejandra";
              arguments = [
                "-q"
                "-"
              ];
            };
          };
          language_servers = [
            "nixd"
            "!nil"
            "..."
          ];
          format_on_save = "on";
        };
      };
    };
  };

  home.packages = with pkgs; [
    bun
    nodejs_26
    cargo
    rustc
    gcc
    binutils
    gnumake
    go
    zig
    odin
    ghidra
    kdePackages.qtdeclarative
  ];
}
