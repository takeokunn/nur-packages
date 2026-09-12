{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-phpstan";
  version = "unstable-2026-06-18";

  src = fetchFromGitHub {
    owner = "emacs-php";
    repo = "ob-phpstan";
    rev = "48a6afcca8ea99acb12a2d306ca3e9e3ac4baaf4";
    hash = "sha256-vY7zLr/pcAYLd6u0UGP+W10fcDpz/kCEMqikX6buUyk=";
  };

  meta = {
    description = "Org-babel functions for PHPStan";
    homepage = "https://github.com/emacs-php/ob-phpstan";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
