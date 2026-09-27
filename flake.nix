{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crane.url = "github:ipetkov/crane";
    aitools.url = "github:nerima-lisp/aitools";
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      aitools,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (_: prev: if prev.stdenv.isDarwin then {
              emacs = prev.emacs.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ prev.apple-sdk ];
                NIX_CFLAGS_COMPILE = "-std=gnu11 -include stdbool.h";
              });
            } else { })
          ];
        };
    in
    {
      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          craneLib = crane.mkLib pkgs;
          # aitools' own flake only declares packages for these two systems.
          aitoolsPackage =
            if builtins.elem system [ "x86_64-linux" "aarch64-darwin" ] then
              aitools.packages.${system}.default
            else
              null;
          nurPkgs = import ./default.nix { inherit pkgs craneLib aitoolsPackage; };
        in
        nurPkgs
      );

      packages = forAllSystems (
        system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
      );

      formatter = forAllSystems (system: (pkgsFor system).nixfmt-tree);

      checks = self.packages;
    };
}
