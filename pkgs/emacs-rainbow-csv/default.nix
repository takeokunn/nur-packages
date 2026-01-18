{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "rainbow-csv";
  version = "unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "emacs-vs";
    repo = "rainbow-csv";
    rev = "5b0bbaca8c6c1785b5ddd48fdf16817acc046ad2";
    hash = "sha256-K2sSCOxqsNI0f4bPHQ9Mg3YF0GQDGoQWa9U8HKtcEJs=";
  };

  packageRequires = [ emacsPackages.csv-mode ];

  meta = {
    description = "Rainbow CSV mode for Emacs";
    homepage = "https://github.com/emacs-vs/rainbow-csv";
    license = lib.licenses.gpl3Plus;
  };
}
