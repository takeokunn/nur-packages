{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "arto";
  version = "unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "arto-app";
    repo = "arto.el";
    rev = "e6ff578dd53b545ae120331997ff1c85df0c93de";
    hash = "sha256-mztAwebNal2wWlF05PaAaxkHek/UkJR5uQdNcBaYx1k=";
  };

  meta = {
    description = "An Emacs package to open Markdown files in Arto";
    homepage = "https://github.com/arto-app/arto.el";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
