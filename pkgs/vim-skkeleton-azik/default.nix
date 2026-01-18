{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "skkeleton-azik-kanatable";
  version = "unstable-2024-04-26";

  src = fetchFromGitHub {
    owner = "kei-s16";
    repo = "skkeleton-azik-kanatable";
    rev = "e73e49b147163d204b41aff9a65d34e2c5a75190";
    hash = "sha256-VBf3Rpk3W8AXISss80zOx/E7WIL3e7LiCbYTN7NvGoo=";
  };

  meta = {
    description = "skkeleton azik kanatable";
    homepage = "https://github.com/kei-s16/skkeleton-azik-kanatable";
    license = lib.licenses.mit;
  };
}
