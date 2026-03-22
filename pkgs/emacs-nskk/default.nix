{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "nskk";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "nskk.el";
    rev = "v0.1.16";
    hash = "sha256-ptbq0cKocZuUucoLRTSFAq90jFZS3CpO8FxQSj3S1sE=";
  };

  meta = {
    description = "NSKK - SKK Japanese input method for Emacs";
    homepage = "https://github.com/takeokunn/nskk.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
