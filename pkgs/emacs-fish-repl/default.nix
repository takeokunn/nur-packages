{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "fish-repl";
  version = "unstable-2024-02-14";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "fish-repl.el";
    rev = "5dd66957e494ea201de6e2b0c934dbac6f12743a";
    hash = "sha256-6clzUsB7dllXKe5CeT0kwZl5Cjs9KKhPFaDa9B0aUHE=";
  };

  packageRequires = [ emacsPackages.f ];

  meta = {
    description = "Fish shell REPL for Emacs";
    homepage = "https://github.com/takeokunn/fish-repl.el";
    license = lib.licenses.gpl3Plus;
  };
}
