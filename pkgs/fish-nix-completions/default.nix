{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-nix-completions";
  version = "unstable-2023-06-27";

  src = fetchFromGitHub {
    owner = "kidonng";
    repo = "nix-completions.fish";
    rev = "cd8a43bed96e0acc02228bc77502be8ba5fa0548";
    hash = "sha256-spnLmde41qQt8uJZFwiH0igFuVqZ6SvkwdA9Kbe2yz8=";
  };

  meta = {
    description = "Fish shell completions for Nix";
    homepage = "https://github.com/kidonng/nix-completions.fish";
    license = lib.licenses.unlicense;
  };
}
