{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crane.url = "github:ipetkov/crane";
  };

  outputs = { self, nixpkgs, crane }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
      {
        legacyPackages = forAllSystems (system:
          let
            pkgs = import nixpkgs { inherit system; };
            craneLib = crane.mkLib pkgs;
          in
          import ./default.nix {
            inherit pkgs craneLib;
          }
        );
        packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
      };
}
