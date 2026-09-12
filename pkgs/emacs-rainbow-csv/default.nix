{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "rainbow-csv";
  version = "unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "emacs-vs";
    repo = "rainbow-csv";
    rev = "5763375e48e870ffd284e051eb2428cac743d7e0";
    hash = "sha256-NcFI38TnPHWMUdwX3UBZVjiPj6uCl0+WnIMNdzQ73G8=";
  };

  packageRequires = [ emacsPackages.csv-mode ];

  meta = {
    description = "Rainbow CSV mode for Emacs";
    homepage = "https://github.com/emacs-vs/rainbow-csv";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
