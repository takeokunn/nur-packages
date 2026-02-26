{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "52896db05d63b1bc00204eb4120293557f9586a4";
    hash = "sha256-zjHMdybl+KG2K8FM37wQ+WutZDQXvNr7MZewlsj+dHY=";
  };

  meta = {
    description = "Japanese translation of Vim help files";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
