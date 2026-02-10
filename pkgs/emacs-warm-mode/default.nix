{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "warm-mode";
  version = "unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "smallwat3r";
    repo = "emacs-warm-mode";
    rev = "27362826e970ed0e902bee3512d97dc02f196a7b";
    hash = "sha256-0GS73hleV15m5eCtfUlMEzgBr3EQ5fNtcJLdSmvWdEc=";
  };

  meta = {
    description = "A global minor mode that warms Emacs colors for nighttime coding";
    homepage = "https://github.com/smallwat3r/emacs-warm-mode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
