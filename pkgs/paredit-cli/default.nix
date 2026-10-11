{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-aSmd/jw7b0M7Iw1qJfUQ4cncB1op1w8waCQ8tfxwqaY=";
  };

  cargoHash = "sha256-PDZioH3rw7AfWFKTgm8iN6bEatxFnSDkm18/qLjcFpc=";

  # Upstream runs the suite in its own `nextest` flake check and sets
  # doCheck = false on packages.default for the same reason: re-running 15k
  # tests here adds no coverage, and several of them assert wall-clock ratios
  # that fail under sandbox load rather than on a real regression.
  doCheck = false;

  meta = {
    description = "Structure-editing CLI for safe S-expression refactoring by AI coding agents";
    homepage = "https://github.com/takeokunn/paredit-cli";
    license = lib.licenses.mit;
    mainProgram = "paredit";
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
