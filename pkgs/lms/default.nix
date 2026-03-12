{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_22
, stdenv
}:

buildNpmPackage rec {
  pname = "lms";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "lmstudio-ai";
    repo = "lmstudio-js";
    rev = "refs/tags/v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder: Update after first build
    fetchSubmodules = true;
  };

  # Placeholder hash - update with: nix-prefetch-url --type sha256 <url> or let nix-build fail
  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nodejs = nodejs_22;

  buildPhase = ''
    runHook preBuild

    # Build TypeScript
    npm run build

    # Bundle with Rollup
    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Create bin directory
    mkdir -p $out/bin

    # Install the compiled and bundled entry point
    install -Dm755 dist/index.js $out/lib/node_modules/lms/index.js

    # Create wrapper script
    cat > $out/bin/lms << 'EOF'
    #!${stdenv.shell}
    exec ${nodejs_22}/bin/node $out/lib/node_modules/lms/index.js "$@"
    EOF

    chmod +x $out/bin/lms

    runHook postInstall
  '';

  # Hash update procedure:
  # 1. Set npmDepsHash to lib.fakeSha256
  # 2. Run nix-build -E '((import <nixpkgs> {}).callPackage ./default.nix {})' | head -c 10000
  # 3. Copy the actual hash from error message and update npmDepsHash
  # 4. Rebuild to verify

  meta = with lib; {
    description = "LMS (Language Model Studio) JavaScript SDK CLI tool";
    homepage = "https://github.com/lmstudio-ai/lmstudio-js";
    license = licenses.mit;
    maintainers = with maintainers; [ takeokunn ];
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "lms";
    broken = true;
  };
}
