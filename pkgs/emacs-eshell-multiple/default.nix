{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "eshell-multiple";
  version = "unstable-2023-12-17";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "eshell-multiple";
    rev = "342c36ef9c71df8738f4435fd4381f506631e7aa";
    hash = "sha256-+4x8Xkaqj44rcvrqv/3M8p+b842c6uLNBGPMaDtQUbs=";
  };

  meta = {
    description = "Manage multiple eshell buffers in Emacs";
    homepage = "https://github.com/takeokunn/eshell-multiple";
    license = lib.licenses.gpl3Plus;
  };
}
