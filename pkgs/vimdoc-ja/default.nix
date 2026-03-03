{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "26e204ce3b0b03d5e2f69f34dd022cfca19945ac";
    hash = "sha256-Hxtw1kgW8VQhoqrMnPKl74W6R7WM+rJjA55EoCayY38=";
  };

  meta = {
    description = "Japanese translation of Vim help files";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
