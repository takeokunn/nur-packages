{
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarn,
  fixup-yarn-lock
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-jtf-style";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-JTF-style";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-B1ciJYdf/+W53oHn+cxgjBA43wb7ec9vJwc/RxtfXig=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-2+lnxml3GgnXi8amm7TQxo5eUg9B7Fvs1M5mNMaZyRc=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-preset-jtf-style
    cp -r . $out/lib/node_modules/textlint-rule-preset-jtf-style

    runHook postInstall
  '';

  meta = {
    description = "JTF日本語標準スタイルガイド for textlint.";
    homepage = "https://github.com/textlint-ja/textlint-rule-preset-JTF-style";
  };
})
