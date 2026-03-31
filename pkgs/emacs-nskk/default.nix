{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "nskk";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "nskk.el";
    rev = "v0.1.20";
    hash = "sha256-t6u9slKxv+Kvz9eChZ5VuyufAezXtcGGHteZKJ/JWOM=";
  };

  meta = {
    description = "NSKK - SKK Japanese input method for Emacs";
    homepage = "https://github.com/takeokunn/nskk.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
