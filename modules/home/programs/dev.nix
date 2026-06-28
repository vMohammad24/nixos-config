{pkgs, ...}: {
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
      "ini"
      "rainbow-csv"
      "svelte"
      "html"
      "nix"
      "toml"
      "zig"
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
      };
      languages = {
        Astro = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        CSS = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        GraphQL = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        HTML = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        JSON = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        JSONC = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        JSX = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        JavaScript = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        Svelte = {
          language_servers = [
            "!biome"
            "..."
          ];
        };
        TSX = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        TypeScript = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
          };
        };
        "Vue.js" = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
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
    ghidra
  ];
}
