{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "skkeleton";
  version = "unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "vim-skk";
    repo = "skkeleton";
    rev = "5fd94f5912ceffc4d6ea167d78e45949a9e2f18c";
    hash = "sha256-Z/3hQTt4uHj8FsunQzX3btyxuzMhTkKBTQ0UMx8Usn0=";
  };

  meta = {
    description = "SKK implements for Vim/Neovim with denops.vim";
    homepage = "https://github.com/vim-skk/skkeleton";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
