{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "warm-mode";
  version = "unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "smallwat3r";
    repo = "emacs-warm-mode";
    rev = "56309813b86daf20b663b457221569b49c5199f2";
    hash = "sha256-ZSp3NaoewdPZGk7amtHsb7rrK6ziGw94YfVauVY2KH4=";
  };

  meta = {
    description = "A global minor mode that warms Emacs colors for nighttime coding";
    homepage = "https://github.com/smallwat3r/emacs-warm-mode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
