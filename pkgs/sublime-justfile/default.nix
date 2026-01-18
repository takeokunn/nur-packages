{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "sublime-justfile";
  version = "unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "nk9";
    repo = "just_sublime";
    rev = "f42cdb012b6033035ee46bfeac1ecd7dca460e55";
    hash = "sha256-VxI5BPrNVOwIRwdZKm8OhTuXCVKOdG8OGKiCne9cwc8=";
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
  };
}
