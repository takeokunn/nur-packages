{ lib, stdenv, requireFile, undmg, writeText }:

stdenv.mkDerivation rec {
  pname = "lmstudio";
  version = "0.4.0";

  src = requireFile rec {
    name = "LM-Studio-${version}.dmg";
    url = "https://lmstudio.ai/";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -r "LM Studio.app" $out/Applications/
  '';

  meta = with lib; {
    description = "LM Studio is an easy to use desktop app for running local LLMs";
    homepage = "https://lmstudio.ai/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "LM Studio";
  };
}
