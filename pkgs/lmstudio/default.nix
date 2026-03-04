{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "lmstudio";
  version = "0.4.5-2";

  src = fetchurl {
    url = "https://installers.lmstudio.ai/darwin/arm64/${version}/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-mSszzDsoXv2D9Ky3K/P2Nn/mixq3HzGMonS1I4mz5+s=";
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
    platforms = [ "aarch64-darwin" ];
    mainProgram = "LM Studio";
  };
}
