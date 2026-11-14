{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "23bb2bcc8b4fdb90c126a01967fc29e22b516bbd";
    hash = "sha256-SoIUKGPABEjpbysr7Ur0Y/bwQ2xY3UA+cPwBuQsq57M=";
  };

  meta = {
    description = "Japanese translation of Vim help files";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
