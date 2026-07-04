{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "kuro";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "kuro";
    rev = "ff306f56c63cbe2a6471d51728a14f9aec474ded";
    hash = "sha256-MQpgJG0/mrgi0zt7NIt/G1LL++ps6XjAPvmgh9snMKQ=";
  };

  cargoHash = "sha256-JCJd2DyW4cQ+9fNy6zhSMJdo9dYcs1Uo8LGnctVYmRI=";

  cargoBuildFlags = [
    "-p"
    "kuro-core"
    "--lib"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    if [[ "$(uname -s)" == "Darwin" ]]; then
      module="libkuro_core.dylib"
    else
      module="libkuro_core.so"
    fi
    built_module="$(find target -name "$module" -print -quit)"
    cp "$built_module" "$out/lib/$module"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kuro terminal emulator module for Emacs";
    homepage = "https://github.com/takeokunn/kuro";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
