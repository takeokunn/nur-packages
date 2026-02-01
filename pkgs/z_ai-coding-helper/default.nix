# @z_ai/coding-helper - GLM Coding Plan Helper for managing coding tools
#
# This package is built from the npm registry tarball since no public source
# repository exists. The package-lock.json is generated and maintained locally.
#
# Update instructions:
# 1. Update the version variable below
# 2. Run: nix-prefetch-url "https://registry.npmjs.org/@z_ai/coding-helper/-/coding-helper-<VERSION>.tgz"
# 3. Convert hash: nix hash convert --hash-algo sha256 --to sri <HASH>
# 4. Download tarball, extract, and regenerate package-lock.json:
#    curl -sL "https://registry.npmjs.org/@z_ai/coding-helper/-/coding-helper-<VERSION>.tgz" | tar xz
#    cd package && npm install --package-lock-only
# 5. Run: nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps package-lock.json
# 6. Update hash and npmDepsHash below
# 7. Copy new package-lock.json to this directory
{
  lib,
  buildNpmPackage,
  fetchurl,
  runCommand,
  jq,
  nodejs_22,
}:

let
  version = "0.0.7";

  tarball = fetchurl {
    url = "https://registry.npmjs.org/@z_ai/coding-helper/-/coding-helper-${version}.tgz";
    hash = "sha256-OJe8fF4ohJ+2XDnM8DrLwFdslHliGTP6ApbungIBxwM=";
  };

  src = runCommand "z_ai-coding-helper-src-${version}" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar xzf ${tarball} -C $out --strip-components=1
    # Remove devDependencies from package.json to avoid npm trying to fetch them
    jq 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "z_ai-coding-helper";
  inherit version src;

  nodejs = nodejs_22;

  npmDepsHash = "sha256-qLd5r5EmOyt/nWb2498T/bSxJpwk4+z0Sb4xmfxn4iU=";

  dontNpmBuild = true;

  meta = {
    description = "GLM Coding Plan Helper for managing multiple coding tools";
    homepage = "https://docs.z.ai/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
    mainProgram = "chelper";
  };
}
