{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-ViCg+OK60SyUtvK/sAU2u6FaArK2gHBUyiNOC0EpCi8=";
  };

  cargoHash = "sha256-R208oiVq0QUMqylaU02tHGoiNGCHj/Xrvz+UIX60UZY=";

  meta = {
    description = "Structure-editing CLI for safe S-expression refactoring by AI coding agents";
    homepage = "https://github.com/takeokunn/paredit-cli";
    license = lib.licenses.mit;
    mainProgram = "paredit";
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
