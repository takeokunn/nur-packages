{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "cec7845cdd30e40b72c6f2dee173e85cba019791";
    hash = "sha256-LSpo9J6m5N9D2XTcrl2G0R6UN/5uFd4LSrqdbZi3jSY=";
  };

  meta = {
    description = "Japanese translation of Vim help files";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
