{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "eldev";
  version = "1.11.2";
  src = fetchFromGitHub {
    owner = "emacs-eldev";
    repo = "eldev";
    rev = version;
    hash = "sha256-X23/tnSbdqW1Xcuz4Hnrv5o1VNAm37H+1sOH+vZVGM4=";
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
