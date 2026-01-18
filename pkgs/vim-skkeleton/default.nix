{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "skkeleton";
  version = "unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "vim-skk";
    repo = "skkeleton";
    rev = "158ae753bc5099ab12537c23152926c42b1f7c3a";
    hash = "sha256-Ee55oGlNCoKwvDxaJyRCjqY89+DU2bP+7t8o/kkh8lU=";
  };

  meta = {
    description = "SKK implements for Vim/Neovim with denops.vim";
    homepage = "https://github.com/vim-skk/skkeleton";
    license = lib.licenses.mit;
  };
}
