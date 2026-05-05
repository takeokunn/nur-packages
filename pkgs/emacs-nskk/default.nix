{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "nskk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "nskk.el";
    rev = "v0.2.0";
    hash = "sha256-zjZpLxq3XiZxhTXVsII0cVnx1WTH5FRj0uOJs8WW+ww=";
  };

  meta = {
    description = "NSKK - SKK Japanese input method for Emacs";
    homepage = "https://github.com/takeokunn/nskk.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
