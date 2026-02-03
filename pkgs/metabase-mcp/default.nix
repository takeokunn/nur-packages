{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs_22,
  nodejs-slim_22,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metabase-mcp";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "metabase-mcp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4tzSvnXUxa8Q79nNYWWZGm69ITjdboTLTfLz51iYhkM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-9NIW93k3rnTkJas/U1RmBNlPXdIVwmKjjfoap0q49Qc=";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    nodejs_22
    pnpmConfigHook
    pnpm_10
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/metabase-mcp}

    cp -r dist $out/lib/metabase-mcp/
    cp -r node_modules $out/lib/metabase-mcp/
    cp package.json $out/lib/metabase-mcp/

    makeBinaryWrapper ${nodejs-slim_22}/bin/node $out/bin/metabase-mcp \
      --add-flags "$out/lib/metabase-mcp/dist/index.js"
    runHook postInstall
  '';

  meta = {
    description = "MCP server for Metabase integration";
    homepage = "https://github.com/takeokunn/metabase-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "metabase-mcp";
  };
})
