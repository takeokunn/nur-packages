{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  craneLib,
  nodejs-slim,
  pnpm_9,
  pnpmConfigHook,
  dioxus-cli,
  darwin,
  writeShellScriptBin,
}:

let
  version = "0.15.1";
  pname = "arto";

  srcRepo = fetchFromGitHub {
    owner = "arto-app";
    repo = "Arto";
    rev = "ca1365afff67bc3e5690c162d343e26c2ec90d52";
    hash = "sha256-jx9L6jc8usWUaSUL2OSmJnPBtuYKoXM4v20J9RzLlTA=";
  };

  isDarwin = stdenv.hostPlatform.isDarwin;

  appBundleName = "Arto.app";
  dxBundlePath = "target/dx/${pname}/bundle/macos/bundle/macos";

  renderer-assets = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-renderer-assets";
    inherit version;
    src = "${srcRepo}/renderer";

    nativeBuildInputs = [
      nodejs-slim
      pnpm_9
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_9;
      hash = "sha256-te2RlBOaftaTvBrrXLyuS0fcv0u94m1htAjnKuU1LwQ=";
      fetcherVersion = 2;
    };

    buildPhase = ''
      runHook preBuild
      export VITE_OUT_DIR=$out
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      runHook postInstall
    '';
  });

  codesignWrapperScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    args=()
    target=""

    for arg in "$@"; do
      if [[ "$arg" != -* ]] && [[ -e "$arg" ]]; then
        target="$arg"
      fi
      args+=("$arg")
    done

    if [[ -d "$target" ]]; then
      while IFS= read -r -d $'\0' f; do
        file_args=()
        for arg in "''${args[@]}"; do
          if [[ "$arg" == "$target" ]]; then
            file_args+=("$f")
          else
            file_args+=("$arg")
          fi
        done
        @CODESIGN_BIN@ "''${file_args[@]}" 2>/dev/null || true
      done < <(find "$target" -type f -print0)
    else
      exec @CODESIGN_BIN@ "$@"
    fi
  '';

  codesignWrapper = writeShellScriptBin "codesign" (
    builtins.replaceStrings [ "@CODESIGN_BIN@" ] [ "${darwin.sigtool}/bin/codesign" ]
      codesignWrapperScript
  );

  xattrWrapper = writeShellScriptBin "xattr" ''
    exit 0
  '';

  commonArgs = {
    inherit pname version;
    src = srcRepo;
    cargoLock = "${srcRepo}/desktop/Cargo.lock";
    cargoToml = "${srcRepo}/desktop/Cargo.toml";
    postUnpack = ''
      cd $sourceRoot/desktop
      sourceRoot="."
    '';
    strictDeps = true;
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

in

if !isDarwin then
  null
else
  craneLib.buildPackage (
    commonArgs
    // {
      inherit cargoArtifacts;

      nativeBuildInputs = [
        codesignWrapper
        xattrWrapper
      ]
      ++ [
        dioxus-cli
      ]
      ++ [
        darwin.autoSignDarwinBinariesHook
      ];

      postPatch = ''
        mkdir -p assets/dist
        cp -r ${renderer-assets}/* assets/dist/

        cp -r ${srcRepo}/extras ../extras
        cp ${srcRepo}/LICENSE ../LICENSE
      '';

      buildPhaseCargoCommand = ''
        dx bundle --release --platform desktop --package-types macos
      '';

      doNotPostBuildInstallCargoBinaries = true;

      installPhaseCommand = ''
        app_path="${dxBundlePath}/${appBundleName}"

        if [[ ! -d "$app_path" ]]; then
          echo "Error: Expected .app bundle not found at $app_path"
          echo "Searching for ${appBundleName} in target/dx..."
          find target/dx -name "${appBundleName}" -type d || true
          exit 1
        fi

        mkdir -p $out/Applications
        cp -r "$app_path" $out/Applications/
      '';

      meta = {
        description = "A local-first Markdown reader for macOS";
        homepage = "https://github.com/arto-app/Arto";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ takeokunn ];
        platforms = lib.platforms.darwin;
      };
    }
  )
