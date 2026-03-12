{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "nskk";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "nskk.el";
    rev = "v0.1.2";
    hash = "sha256-bFhPl3TAP6XglHhQBeVGuybgqvj7f7m41CNkHQ7dEvQ=";
  };

  meta = {
    description = "NSKK - SKK Japanese input method for Emacs";
    homepage = "https://github.com/takeokunn/nskk.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
