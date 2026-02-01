{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-ghq";
  version = "unstable-2023-02-11";

  src = fetchFromGitHub {
    owner = "decors";
    repo = "fish-ghq";
    rev = "cafaaabe63c124bf0714f89ec715cfe9ece87fa2";
    hash = "sha256-6b1zmjtemNLNPx4qsXtm27AbtjwIZWkzJAo21/aVZzM=";
  };

  meta = {
    description = "ghq wrapper function for fish shell";
    homepage = "https://github.com/decors/fish-ghq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
}
