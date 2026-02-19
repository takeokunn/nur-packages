{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "9a9dc4c88d6fa2b2832c92cb98d44636a3cdce0d";
    hash = "sha256-6asHUTuZX8+eWj7fF22M87eCdD53SHBtR9RrXJuR9us=";
  };

  meta = {
    description = "Japanese translation of Vim help files";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
