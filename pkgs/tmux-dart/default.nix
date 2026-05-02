{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "tmux-dart";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "tmux-dart";
    rev = "refs/tags/v0.1.0";
    hash = "sha256-oDDqBreKvYY5F2uE/U2IMQjwE9eXIbp1fnbXmkCU8/s=";
  };

  cargoHash = "sha256-fegGJRzgEP0Y2S6JUZmF6jscHaP5BkbAfQ1NY118VYM=";

  meta = {
    description = "EasyMotion-like cursor-jump plugin for tmux";
    homepage = "https://github.com/takeokunn/tmux-dart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "tmux-dart";
  };
}
