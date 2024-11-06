{
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarn,
  fixup-yarn-lock
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-ja-spacing";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-ja-spacing";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-M27qhjIHMcKbuPAh523Pi5IB5BD0VWawh84kUyLcKvg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-AfbYACqYBvfsKzhryQabXQQmera19N/UH67sR5kbihM=";
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
