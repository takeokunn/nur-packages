{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "zalgo-mode";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "nehrbash";
    repo = "zalgo-mode";
    rev = "dc42228ce38db4f9879d6d53ba68207f2a5f7474";
    hash = "sha256-R1fidCbailFsZZsQWNCznXqLuY3mG4bVL7rlxb1N2sg=";
  };

  meta = {
    description = "Zalgo text generator for Emacs";
    homepage = "https://github.com/nehrbash/zalgo-mode";
    license = lib.licenses.gpl3Plus;
  };
}
