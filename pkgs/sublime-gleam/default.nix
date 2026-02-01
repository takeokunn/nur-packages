{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "sublime-gleam";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "molnarmark";
    repo = "sublime-gleam";
    rev = "ff9638511e05b0aca236d63071c621977cffce38";
    hash = "sha256-94moZz9r5cMVPWTyzGlbpu9p2p/5Js7/KV6V4Etqvbo=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sublime
    cp -r . $out/share/sublime/
    runHook postInstall
  '';

  meta = {
    description = "Gleam syntax highlighting for Sublime Text";
    homepage = "https://github.com/molnarmark/sublime-gleam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
