{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "eldev";
  version = "1.11.1";
  src = fetchFromGitHub {
    owner = "emacs-eldev";
    repo = "eldev";
    rev = version;
    hash = "sha256-C95D/d8z4ClfEtlp8Hi4uX67FfPsyWKa0A4wur7vyGk=";
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
