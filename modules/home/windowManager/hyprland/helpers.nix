{lib}: let
  inherit (lib.generators) mkLuaInline;
in rec {
  # binds
  bind = keys: dispatcher: {
    _args = [
      (mkLuaInline keys)
      (mkLuaInline dispatcher)
    ];
  };

  bindFlags = keys: dispatcher: flags: {
    _args = [
      (mkLuaInline keys)
      (mkLuaInline dispatcher)
      flags
    ];
  };

  bindMod = keys: dispatcher: bind "mainMod .. \" + ${keys}\"" dispatcher;
  bindModFlags = keys: dispatcher: flags: bindFlags "mainMod .. \" + ${keys}\"" dispatcher flags;

  bindExec = keys: cmd: bindMod keys "hl.dsp.exec_cmd(\"${cmd}\")";

  bindWindow = keys: action: let
    dispatchers = {
      close = "hl.dsp.window.close()";
      exit = "hl.dsp.exit()";
      float = "hl.dsp.window.float({ action = \"toggle\" })";
      fullscreen = "hl.dsp.window.fullscreen({ action = \"toggle\" })";
      maximize = "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })";
    };
  in
    bindMod keys dispatchers.${action};

  bindFocus = keys: dir: bindMod keys "hl.dsp.focus({ direction = \"${dir}\" })";

  bindWorkspace = keys: ws: bindMod keys "hl.dsp.focus({ workspace = ${toString ws} })";
  bindMoveToWorkspace = keys: ws: bindMod keys "hl.dsp.window.move({ workspace = ${toString ws} })";

  # anims
  curve = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };

  anim = leaf: speed: bezier: extra:
    {
      inherit leaf speed bezier;
      enabled = true;
    }
    // extra;

  # monitors
  monitor = args: {_args = [args];};

  # rules
  workspaceRule = workspace: monitor: {inherit workspace monitor;};

  windowRule = name: match: extra:
    {
      inherit name match;
    }
    // extra;

  # env
  env = name: value: {
    _args = [name value];
  };

  # hooks
  onStart = commands: {
    _args = [
      "hyprland.start"
      (mkLuaInline ''
        function()
          ${lib.concatMapStringsSep "\n          " (cmd: "hl.exec_cmd(\"${cmd}\")") commands}
        end
      '')
    ];
  };
}
