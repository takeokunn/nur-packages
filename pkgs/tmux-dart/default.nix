{
  lib,
  rustPlatform,
  fetchFromGitHub,
  tmuxPlugins,
  makeWrapper,
}:

let
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "tmux-dart";
    rev = "refs/tags/v${version}";
    hash = "sha256-KIa4vs3Uv8zi4z5nu8k9SCSChhO8asKHYO13k2fLR/s=";
  };

  binary = rustPlatform.buildRustPackage {
    pname = "tmux-dart";
    inherit version src;
    cargoHash = "sha256-fegGJRzgEP0Y2S6JUZmF6jscHaP5BkbAfQ1NY118VYM=";
  };
in

tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-dart";
  inherit version src;
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/share/tmux-plugins/tmux-dart/tmux-dart.tmux \
      --set TMUX_DART_BINARY ${binary}/bin/tmux-dart
  '';

  meta = {
    description = "EasyMotion-like cursor-jump plugin for tmux";
    homepage = "https://github.com/takeokunn/tmux-dart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
  };
}
