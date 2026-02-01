{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-racket";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "hasu";
    repo = "emacs-ob-racket";
    rev = "c7b7eee58fcde2ad515b72288742e555e7ec7915";
    hash = "sha256-yv+PP1JyEvMxEToNbgDbgWih/GHdauwfYLzPaEPsEC8=";
  };

  meta = {
    description = "Org-babel functions for Racket";
    homepage = "https://github.com/hasu/emacs-ob-racket";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
