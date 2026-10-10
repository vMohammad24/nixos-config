{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nix-amd-ai.nixosModules.default];

  options.myConfig.ai.enable = lib.mkEnableOption "AMD AI stuff";

  config = lib.mkMerge [
    (lib.mkIf config.myConfig.ai.enable {
      hardware.amd-npu = {
        enable = true;
        enableNPU = false;
        enableFastFlowLM = false;
        enableLemonade = true;
        enableROCm = false;
        enableVulkan = true;
        enableImageGen = true;
        lemonade.user = "vmohammad";
      };
      users.users.vmohammad.extraGroups = ["video" "render"];
    })
    (lib.mkIf (!config.myConfig.ai.enable) {
      nixpkgs.overlays = [
        (final: prev: {
          whisper-cpp = inputs.nixpkgs.legacyPackages.${prev.system}.whisper-cpp;
          llama-cpp = inputs.nixpkgs.legacyPackages.${prev.system}.llama-cpp;
        })
      ];
    })
  ];
}
