{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    crane.url = "github:ipetkov/crane";
    arto = {
      url = "github:arto-app/arto/v0.15.1";
      inputs.crane.follows = "crane";
    };
  };

  outputs = { self, nixpkgs, crane, arto }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
      {
        legacyPackages = forAllSystems (system: import ./default.nix {
          pkgs = import nixpkgs { inherit system; };
          artoFlake = arto;
          inherit system;
        });
        packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
      };
}
