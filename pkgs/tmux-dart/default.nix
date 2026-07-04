{
  lib,
  rustPlatform,
  fetchFromGitHub,
  tmuxPlugins,
  makeWrapper,
}:

let
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "tmux-dart";
    rev = "refs/tags/v${version}";
    hash = "sha256-h6b3U2JWE3oXgPtVxTdzYGt8DIUll9Ej/oypaGWvKlI=";
  };

  binary = rustPlatform.buildRustPackage {
    pname = "tmux-dart";
    inherit version src;
    cargoHash = "sha256-DIxND1ecDZpSaJg6Ts/y8p3abiHr+dFH4xk0wMZkAeY=";
  };
in

tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-dart";
  rtpFilePath = "tmux-dart.tmux";
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
