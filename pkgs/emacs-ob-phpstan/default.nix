{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-phpstan";
  version = "unstable-2023-03-11";

  src = fetchFromGitHub {
    owner = "emacs-php";
    repo = "ob-phpstan";
    rev = "99ab8b56b92037a89fa5493697b149c937ed4b2b";
    hash = "sha256-ZvMvYhGbLiCagKQoH4WC0bSAqLLIqCJaDzsuG6VHF/o=";
  };

  meta = {
    description = "Org-babel functions for PHPStan";
    homepage = "https://github.com/emacs-php/ob-phpstan";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
