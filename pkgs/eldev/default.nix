{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "eldev";
  version = "1.11.4";
  src = fetchFromGitHub {
    owner = "emacs-eldev";
    repo = "eldev";
    rev = version;
    hash = "sha256-1STgH4uWrboDZUDdc6C0LEuHKP7cjAxhhLTdtf/qCOs=";
  };
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/eldev $out/bin/
    chmod +x $out/bin/eldev
    runHook postInstall
  '';
  meta = {
    description = "Elisp Development Tool";
    homepage = "https://github.com/emacs-eldev/eldev";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "eldev";
  };
}
