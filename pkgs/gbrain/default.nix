{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  # scripts/update-packages.sh moves this to the release the upstream `stable` tag points at.
  version = "0.60.768.0";

  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/garrytan/gbrain/releases/download/v${version}/gbrain-darwin-arm64";
      hash = "sha256-ipoAD94Fph+I59so/0mNOBJTrH4ExZPeSay+iKRGa6o=";
    };
    "x86_64-linux" = {
      url = "https://github.com/garrytan/gbrain/releases/download/v${version}/gbrain-linux-x64";
      hash = "sha256-YWWp/CrjGoiFbbf8kpAX+SIAfWCVpur4LdTnV2WuRZ0=";
    };
  };

  platform = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "gbrain";
  inherit version;

  src = fetchurl {
    inherit (platform) url hash;
  };

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  # A `bun build --compile` executable carries its JavaScript payload in a `.bun` ELF section or a
  # `__BUN` Mach-O segment, and the Darwin binary is ad-hoc signed; stripping can damage either.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/gbrain
    runHook postInstall
  '';

  meta = {
    description = "Agent memory brain served over MCP, with keyword and semantic retrieval";
    homepage = "https://github.com/garrytan/gbrain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "gbrain";
  };
}
