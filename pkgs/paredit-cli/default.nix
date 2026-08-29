{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-UHHLK5Q9ZuO+CdpwRL32T9TqAxQj+pKSKXUZXZ7z7+k=";
  };

  cargoHash = "sha256-BTuJLGLAr19I9ylWyk4FDnZ9bA3qKP4T+PUTYJW7zwU=";

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
