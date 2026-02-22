{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-gleam";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "ob-gleam";
    rev = "v0.1.1";
    hash = "sha256-0ToygUIWE+o3wAWzaIeCPEEgDKGxlCDni+HZYIBDNIA=";
  };

  meta = {
    description = "Org Babel support for Gleam";
    homepage = "https://github.com/takeokunn/ob-gleam";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
