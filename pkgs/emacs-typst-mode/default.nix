{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "typst-mode";
  version = "unstable-2024-06-14";

  src = fetchFromGitHub {
    owner = "Ziqi-Yang";
    repo = "typst-mode.el";
    rev = "5776fd4f3608350ff6a2b61b118d38165d342aa3";
    hash = "sha256-mqkcNDgx7lc6kUSFFwSATRT+UcOglkeu+orKLiU9Ldg=";
  };

  packageRequires = [ emacsPackages.polymode ];

  meta = {
    description = "Emacs major mode for Typst";
    homepage = "https://github.com/Ziqi-Yang/typst-mode.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
