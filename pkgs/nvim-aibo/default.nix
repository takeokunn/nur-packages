{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "nvim-aibo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "nvim-aibo";
    rev = "ede45dca805afab44941046088dacc031086d6b2";
    hash = "sha256-1ZWuRBF6Qn6+HJHHdDZjUwbbt2+Nj6IN9BkHjkrfZks=";
  };

  meta = {
    description = "Aibo (AI Bot) for Neovim written in Denops";
    homepage = "https://github.com/lambdalisue/nvim-aibo";
    license = lib.licenses.mit;
  };
}
