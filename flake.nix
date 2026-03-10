{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crane.url = "github:ipetkov/crane";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      devenv,
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
        };
    in
    {
      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          craneLib = crane.mkLib pkgs;
          nurPkgs = import ./default.nix { inherit pkgs craneLib; };
        in
        nurPkgs // {
          devenv = devenv.packages.${system}.devenv;
        }
      );

      packages = forAllSystems (
        system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
      );

      formatter = forAllSystems (system: (pkgsFor system).nixfmt-tree);

      checks = self.packages;
    };
}
