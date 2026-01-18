{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-artisan-completion";
  version = "unstable-2020-02-25";

  src = fetchFromGitHub {
    owner = "adriaanzon";
    repo = "fish-artisan-completion";
    rev = "8e8d726b3862fcb972abb652fb8c1a9fb9207a64";
    hash = "sha256-+LKQVuWORJcyuL/YZ3B86hpbV4rbSkj41Y9qgwXZXu4=";
  };

  meta = {
    description = "Fish shell completions for Laravel Artisan";
    homepage = "https://github.com/adriaanzon/fish-artisan-completion";
    license = lib.licenses.mit;
  };
}
