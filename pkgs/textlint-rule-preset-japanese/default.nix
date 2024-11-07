{
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarn,
  fixup-yarn-lock
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-japanese";
  version = "10.0.3";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-japanese";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-I/9q5f8lUsHyf0Zya9S0Mb9BXJ2GEgT56rHNG/1isAA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-si3U3OyPLU5LaWsckmtkH7bLVC5pLEkTyIY/tq/fBNs=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    fixup-yarn-lock
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    yarn --offline --production install
    mkdir -p $out/lib/node_modules/${finalAttrs.pname}
    cp -r . $out/lib/node_modules/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = {
    description = "textlint rule preset for Japanese.";
    homepage = "https://github.com/textlint-ja/textlint-rule-preset-japanese";
  };
})
