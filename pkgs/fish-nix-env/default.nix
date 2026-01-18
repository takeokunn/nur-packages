{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-nix-env";
  version = "unstable-2021-02-08";

  src = fetchFromGitHub {
    owner = "lilyball";
    repo = "nix-env.fish";
    rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
    hash = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
  };

  meta = {
    description = "Fish plugin that adds nix-shell support";
    homepage = "https://github.com/lilyball/nix-env.fish";
    license = lib.licenses.mit;
  };
}
