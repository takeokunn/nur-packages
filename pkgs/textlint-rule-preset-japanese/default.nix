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
  version = "10.0.4";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-japanese";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-i7DVkSLGEVk+asTS2obNtW0OtZq8vPXkwC0JeEsGlh8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mFZLBtG3Y/etLGf+dhyPbhxlQnoMhV845AKhaRu8iqk=";
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
