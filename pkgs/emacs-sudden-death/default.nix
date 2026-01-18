{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "sudden-death";
  version = "unstable-2016-03-19";

  src = fetchFromGitHub {
    owner = "yewton";
    repo = "sudden-death.el";
    rev = "791a63d3f4df192e71f4232a9a4c5588f4b43dfb";
    hash = "sha256-+h6nWW9upcwWfIvYaF4It38+ouhqeBttm1dVbxpvanw=";
  };

  meta = {
    description = "Sudden death generator for Emacs";
    homepage = "https://github.com/yewton/sudden-death.el";
    license = lib.licenses.mit;
  };
}
