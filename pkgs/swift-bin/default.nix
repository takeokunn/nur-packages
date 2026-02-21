{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation rec {
  pname = "swift-bin";
  version = "6.2.3";

  src = fetchurl {
    url = "https://download.swift.org/swift-${version}-release/xcode/swift-${version}-RELEASE/swift-${version}-RELEASE-osx.pkg";
    hash = "sha256-we2Ez1QyhsVJyqzMR+C0fYxhw8j+284SBd7cvr52Aag=";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    xar -xf $src
    gunzip -dc swift-*-RELEASE-osx-package.pkg/Payload | cpio -id
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out

    # The .pkg Payload extracts directly to usr/ and Developer/
    # Use cp -a to preserve symlinks; suppress errors for
    # system-referenced files (e.g., /usr/bin/sudo hardlinks)
    cp -a usr/lib "$out/" 2>/dev/null || true
    cp -a usr/include "$out/" 2>/dev/null || true
    cp -a usr/libexec "$out/" 2>/dev/null || true
    cp -a usr/local "$out/" 2>/dev/null || true
    cp -a usr/share "$out/" 2>/dev/null || true

    # For bin/, only copy real files and relative symlinks
    # (skip absolute symlinks to system tools like /usr/bin/sudo)
    mkdir -p $out/bin
    find usr/bin -maxdepth 1 -type f -exec cp {} "$out/bin/" \;
    find usr/bin -maxdepth 1 -type l | while read -r link; do
      target=$(readlink "$link")
      if [[ "$target" != /* ]]; then
        cp -a "$link" "$out/bin/"
      fi
    done

    # Platform SDKs (needed for compilation)
    cp -a Developer "$out/" 2>/dev/null || true

    # Verify essential binaries
    test -x "$out/bin/swift"
  '';

  # Apple-signed binaries must not be modified
  dontStrip = true;
  dontPatchShebangs = true;
  dontFixup = true;

  meta = with lib; {
    description = "Apple Swift ${version} toolchain (binary distribution from swift.org)";
    homepage = "https://www.swift.org";
    license = licenses.asl20;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "swift";
  };
}
