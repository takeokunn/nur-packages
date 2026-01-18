{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ox-hatena";
  version = "unstable-2020-06-05";

  src = fetchFromGitHub {
    owner = "zonkyy";
    repo = "ox-hatena";
    rev = "24777234566f5472b0e8b3c5faeb2e045fd91e12";
    hash = "sha256-gQ6oU2t/xlyTK4FRInqeHd9AH+vRpCBM/aMbpn1tHTU=";
  };

  meta = {
    description = "Hatena markup exporter for Org-mode";
    homepage = "https://github.com/zonkyy/ox-hatena";
    license = lib.licenses.gpl3Plus;
  };
}
