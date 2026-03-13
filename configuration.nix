{...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system
  ];

  nixpkgs.overlays = [
    (final: prev: {
      python313 = prev.python313.override {
        packageOverrides = pfinal: pprev: {
          picosvg = pprev.picosvg.overrideAttrs (old: {
            doCheck = false;
            dontCheck = true;
            nativeCheckInputs = [];
            checkPhase = "echo skipping tests";
            installCheckPhase = "echo skipping tests";
          });
        };
      };
      python3 = final.python313;
    })
  ];
}
