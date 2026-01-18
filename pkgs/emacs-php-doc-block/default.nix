{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "php-doc-block";
  version = "unstable-2019-06-04";

  src = fetchFromGitHub {
    owner = "moskalyovd";
    repo = "emacs-php-doc-block";
    rev = "bdf1ddba2cadd52ee7dd5691baefc6306ea62c81";
    hash = "sha256-pmCOsKcKcFNZP/ipj5bj9IAK+Ulthso+HQKpzakRCzA=";
  };

  meta = {
    description = "PHP DocBlock generator for Emacs";
    homepage = "https://github.com/moskalyovd/emacs-php-doc-block";
    license = lib.licenses.gpl3Plus;
  };
}
