{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "dasel";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "dasel-el";
    rev = "v0.1.0";
    hash = "sha256-qLbeu4LHFv+ws/qGJsn+6gSkk2odpBkG7RLUpWwu87w=";
  };

  packageRequires = [ emacsPackages.consult ];

  meta = {
    description = "Interactive dasel queries in Emacs with minibuffer + overlay";
    homepage = "https://github.com/takeokunn/dasel-el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
