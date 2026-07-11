{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-8S87jBxvfPlY/+LHM+5oeH2tLd7DqCQRxvOVFU5txEA=";
  };

  cargoHash = "sha256-ffr70x/5iShvxnJXBBfUm79+iws/l7nRHAsrHJrd/FQ=";

  meta = {
    description = "Structure-editing CLI for safe S-expression refactoring by AI coding agents";
    homepage = "https://github.com/takeokunn/paredit-cli";
    license = lib.licenses.mit;
    mainProgram = "paredit";
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
