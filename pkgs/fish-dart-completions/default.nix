{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-dart-completions";
  version = "unstable-2024-10-20";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "fish-dart-completions";
    rev = "f52734d3bbb79f362aa6541b490f74df49f124ff";
    hash = "sha256-CSvMkY5ObtAowr+PsPtJxsWaTZENgP5HrUU/PUoMtOw=";
  };

  meta = {
    description = "Fish shell completions for Dart";
    homepage = "https://github.com/takeokunn/fish-dart-completions";
    license = lib.licenses.mit;
  };
}
