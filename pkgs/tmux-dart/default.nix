{
  lib,
  rustPlatform,
  fetchFromGitHub,
  tmuxPlugins,
  makeWrapper,
}:

let
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "tmux-dart";
    rev = "refs/tags/v${version}";
    hash = "sha256-4kDmHklqHgv3vz1r6a6RaCDc0nBjgPEEmVuIpxm6AIA=";
  };

  binary = rustPlatform.buildRustPackage {
    pname = "tmux-dart";
    inherit version src;
    cargoHash = "sha256-fegGJRzgEP0Y2S6JUZmF6jscHaP5BkbAfQ1NY118VYM=";
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
