{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "lmstudio";
  version = "0.4.5-2";

  src = fetchurl {
    url = "https://installers.lmstudio.ai/darwin/arm64/${version}/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-mSszzDsoXv2D9Ky3K/P2Nn/mixq3HzGMonS1I4mz5+s=";
  };

  sourceRoot = ".";

  # Mount APFS DMG directly via hdiutil (undmg does not support APFS)
  unpackCmd = ''
    echo "Creating temp directory"
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    function finish {
      echo "Ejecting temp directory"
      /usr/bin/hdiutil detach "$mnt" -force
      rm -rf "$mnt"
    }
    trap finish EXIT
    echo "Mounting DMG file into \"$mnt\""
    /usr/bin/hdiutil attach -nobrowse -mountpoint "$mnt" "$curSrc"
    echo "Copying extracted content into \"sourceRoot\""
    cp -a "$mnt/LM Studio.app" "$PWD/"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    # Bypass the /Applications path check in the main index.js
    # LM Studio verifies the app is running from /Applications and shows an
    # error dialog + refuses to auto-update if not. Replace the '/Applications'
    # string literal with '/' so that any absolute path (e.g. /nix/store/...)
    # passes the startsWith check.
    local indexJs="$out/Applications/LM Studio.app/Contents/Resources/app/.webpack/main/index.js"
    substituteInPlace "$indexJs" --replace-quiet "'/Applications'" "'/'"

    runHook postInstall
  '';

  dontFixup = true;

  # hdiutil requires access to /dev and system libs to mount disk images
  __impureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib"
    "/dev/zero"
    "/dev/random"
    "/dev/urandom"
  ];

  meta = with lib; {
    description = "LM Studio is an easy to use desktop app for running local LLMs";
    homepage = "https://lmstudio.ai/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "lm-studio";
  };
}
