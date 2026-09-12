{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "nvim-aibo";
  version = "unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "lambdalisue";
    repo = "nvim-aibo";
    rev = "0505c2ef5471d43fb48df5823ede9705b9c9e73e";
    hash = "sha256-2BAqTUDmW0InXevUiA77BlPPujaj6VHDpCeZXCE9T+s=";
  };

  meta = {
    description = "Aibo (AI Bot) for Neovim written in Denops";
    homepage = "https://github.com/lambdalisue/nvim-aibo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
