{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-sublime";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "sublime";
    rev = "d490b57c08f3d110ff61a07ec6edcc1ed9e24a63";
    hash = "sha256-7veVVrLPW3T7KkkelDmgPW5kp+b12naKSKwCXBgjL1k=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sublime
    cp -r . $out/share/sublime/
    runHook postInstall
  '';

  meta = {
    description = "Dracula theme for Sublime Text";
    homepage = "https://github.com/dracula/sublime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
