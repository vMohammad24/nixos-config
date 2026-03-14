{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "vMohammad24";
        email = "62218284+vMohammad24@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nil
      nixd
      biome
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
    ];
    userSettings = {
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
                ignore = [ ];
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
      };
    };
  };

  home.packages = with pkgs; [
    bun
    nodejs_25
    cargo
    rustc
    gcc
    binutils
    gnumake
    go
    zig
  ];
}
