{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "fish-by-binds-yourself";
  version = "unstable-2024-06-04";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "by-binds-yourself";
    rev = "c807ba8477f20624022b0146645696c1e48d2267";
    hash = "sha256-WZaZvnOPil9CYjdUzjsM9b27TxP3AmxllbRCnxmHtzY=";
  };

  meta = {
    description = "Fish shell plugin for custom key bindings";
    homepage = "https://github.com/atusy/by-binds-yourself";
    license = lib.licenses.mit;
  };
}
