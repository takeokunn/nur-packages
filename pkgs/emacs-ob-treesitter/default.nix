{
  lib,
  emacsPackages,
  fetchFromGitHub,
}:

emacsPackages.trivialBuild {
  pname = "ob-treesitter";
  version = "unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "ob-treesitter";
    rev = "c3fac35f95dcaffdb90836c606d119717c43238d";
    hash = "sha256-3lroCj3FhRS1wgb/UVHYO4CjgP1rsicqB/rARvzsfoc=";
  };

  meta = {
    description = "Org-babel functions for tree-sitter";
    homepage = "https://github.com/takeokunn/ob-treesitter";
    license = lib.licenses.gpl3Plus;
  };
}
