{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vimdoc-ja";
  version = "unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "vim-jp";
    repo = "vimdoc-ja";
    rev = "e114b397e62d1ff336a7b3b3c2b9e888d2eac46b";
    hash = "sha256-SGKklf+pJ7/QiACrBgjt2YP3Dz+BPMpeR31isDbFRcM=";
  };

  meta = {
    description = "Vimのヘルプの日本語訳";
    homepage = "https://github.com/vim-jp/vimdoc-ja";
    license = lib.licenses.vim;
  };
}
