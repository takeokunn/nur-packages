{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-tig";
  version = "unstable-2020-04-25";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "tig";
    rev = "e8a3387d8353e90cca41f5d89c3e1f74f1f7c8c6";
    hash = "sha256-PnBuQJWCqARvjZg/Mfi7imcTa+I4VYvnYSt+GGMzxCQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/tig
    cp config $out/share/tig/dracula.tigrc
    runHook postInstall
  '';

  meta = {
    description = "Dracula theme for tig";
    homepage = "https://github.com/dracula/tig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
