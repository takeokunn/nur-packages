{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-4BNrL/lfP+fOmOXZlaTcjrIhnruc6qWu9JhfRFb9P+w=";
  };

  cargoHash = "sha256-xNSmmC02PYqSodTZWHd27uoQWY8XhIh6acmABpVK0IQ=";

  meta = {
    description = "Structure-editing CLI for safe S-expression refactoring by AI coding agents";
    homepage = "https://github.com/takeokunn/paredit-cli";
    license = lib.licenses.mit;
    mainProgram = "paredit";
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
