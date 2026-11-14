{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "skkeleton";
  version = "unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "vim-skk";
    repo = "skkeleton";
    rev = "42f460d13159068b2773e816b1fa98a9f5b0da22";
    hash = "sha256-bF8/5mlYRzHO6lGeKvHiARfp/bGgCZ7o8dfFPGyWmCM=";
  };

  meta = {
    description = "SKK implements for Vim/Neovim with denops.vim";
    homepage = "https://github.com/vim-skk/skkeleton";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
