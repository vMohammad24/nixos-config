final: prev: {
  proton-cachyos = final.callPackage ./proton-cachyos {};
  netbird = prev.netbird.overrideAttrs (old: {
    version = "0.83.0";
    src = prev.fetchFromGitHub {
      owner = "netbirdio";
      repo = "netbird";
      tag = "v0.83.0";
      hash = "sha256-IvJOA+JGfWi2RK4zf4k8gw+pinYzFnfafNHfZmybdzU=";
    };
    vendorHash = "sha256-iIbATQiIfazszBSi4jl5Ys/27uYwfweEMo+4BLSnRms=";
  });
}
