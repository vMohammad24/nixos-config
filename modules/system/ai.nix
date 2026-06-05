{
  config,
  lib,
  ...
}: {
  options.myConfig.ai.enable = lib.mkEnableOption "AMD AI stuff";

  config = lib.mkIf config.myConfig.ai.enable {
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
  };
}
