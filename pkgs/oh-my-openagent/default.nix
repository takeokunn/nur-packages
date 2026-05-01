{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "3.17.12";

  sources = {
    "aarch64-darwin" = {
      url = "https://registry.npmjs.org/oh-my-opencode-darwin-arm64/-/oh-my-opencode-darwin-arm64-${version}.tgz";
      hash = "sha256-c8nGHL56ODp3vgp+ceVF7kHhtIiyGilR/qxRYcaV404=";
    };
    "x86_64-linux" = {
      url = "https://registry.npmjs.org/oh-my-opencode-linux-x64/-/oh-my-opencode-linux-x64-${version}.tgz";
      hash = "sha256-0GjI2UO4Gd4i/LsWwvioAm5uFKma2TwybcgTP4GZX4c=";
    };
  };

  platform = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "oh-my-opencode";
  inherit version;

  src = fetchurl {
    inherit (platform) url hash;
  };

  sourceRoot = "package";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 bin/oh-my-opencode $out/bin/oh-my-opencode
    runHook postInstall
  '';

  meta = {
    description = "The Best AI Agent Harness - OpenCode plugin with multi-model orchestration and parallel background agents";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.attrNames sources;
    mainProgram = "oh-my-opencode";
  };
}
