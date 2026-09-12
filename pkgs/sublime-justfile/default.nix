{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "sublime-justfile";
  version = "unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "nk9";
    repo = "just_sublime";
    rev = "2dcc60286d1af6a4c6c2c03d50bc03230dc56ce3";
    hash = "sha256-XlxItYVL9I612DhfCGHiUdv6U6Nv9LOlEbJVf1zTwPg=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sublime
    cp -r . $out/share/sublime/
    runHook postInstall
  '';

  meta = {
    description = "Justfile syntax highlighting for Sublime Text";
    homepage = "https://github.com/nk9/just_sublime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
