{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_22
, stdenv
}:

buildNpmPackage rec {
  pname = "lms";
  version = "release-55-4a97771";

  src = fetchFromGitHub {
    owner = "lmstudio-ai";
    repo = "lmstudio-js";
    rev = "refs/tags/${version}";
    hash = "sha256-2pQpWgXDamee3zO9BvRp1HhNyNju2nysQF/yIXwVp34=";
  };

  npmDepsHash = "sha256-dht+Ql/HbislKL2UXZ+nwADwoZJz3jMLhhak3V/O/8Y=";

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
    cat > $out/bin/lms << EOF
    #!${stdenv.shell}
    exec ${nodejs_22}/bin/node $out/lib/node_modules/lms/index.js "\$@"
    EOF

    chmod +x $out/bin/lms

    runHook postInstall
  '';

  meta = with lib; {
    description = "LMS (Language Model Studio) JavaScript SDK CLI tool";
    homepage = "https://github.com/lmstudio-ai/lmstudio-js";
    license = licenses.mit;
    maintainers = with maintainers; [ takeokunn ];
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "lms";
  };
}
