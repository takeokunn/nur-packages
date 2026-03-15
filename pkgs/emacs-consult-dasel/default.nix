{
  lib,
  emacsPackages,
  fetchFromGitHub,
  emacs-dasel,
}:

emacsPackages.trivialBuild {
  pname = "consult-dasel";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "dasel-el";
    rev = "v0.1.1";
    hash = "sha256-uXDi5wgWNaPLuhCG167lXRDJb3USPJZXjZhlR4pDLho=";
  };

  preBuild = ''
    for f in dasel.el dasel-interactive.el dasel-convert.el dasel-format.el dasel-edit.el; do
      rm -f "$f"
    done
  '';

  packageRequires = [
    emacsPackages.consult
    emacs-dasel
  ];

  meta = {
    description = "Consult integration for dasel in Emacs";
    homepage = "https://github.com/takeokunn/dasel-el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
