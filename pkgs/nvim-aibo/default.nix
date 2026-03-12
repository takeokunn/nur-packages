{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "nvim-aibo";
  version = "unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "nvim-aibo";
    rev = "bcbeab88c27cf831a08661eace7a928b2bba5694";
    hash = "sha256-H/bhobPLhIpNI5Zk4sWdiisgULQTXGtsUzDO0CUPTdw=";
  };

  meta = {
    description = "Aibo (AI Bot) for Neovim written in Denops";
    homepage = "https://github.com/lambdalisue/nvim-aibo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
