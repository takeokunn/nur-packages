{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "3.15.1";

  sources = {
    "aarch64-darwin" = {
      url = "https://registry.npmjs.org/oh-my-opencode-darwin-arm64/-/oh-my-opencode-darwin-arm64-${version}.tgz";
      hash = "sha256-VJwmfGtXslq3Orcslh2rgC0/Cy00ZxDWq65HCKlpE0o=";
    };
    "x86_64-linux" = {
      url = "https://registry.npmjs.org/oh-my-opencode-linux-x64/-/oh-my-opencode-linux-x64-${version}.tgz";
      hash = "sha256-1s/c2h02FnqZ8djq6uHkR2If1ve5Du4jniEV94FXTKM=";
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
