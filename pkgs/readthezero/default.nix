{
  lib,
  stdenv,
  fetchFromGitHub,
  lightningcss,
  esbuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readthezero";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "readthezero";
    rev = "b33ab26ee2425204db3125c0e82db278debcf44f";
    hash = "sha256-AqrZe3GN3chgxDzaC+6uFaaM9dWCp/jnLXNknSEZeBo=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    lightningcss
    esbuild
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p out

    lightningcss --minify --bundle --targets '>= 0.25%' base/index.css -o out/readthezero-base.css

    esbuild --minify --target=chrome92,firefox90,safari15.4 js/readthezero.js --outfile=out/readthezero.js

    for theme in default ocean forest arctic autumn cherry contrast dracula gruvbox lavender nord peach rose solarized tokyo-night; do
      lightningcss --minify --bundle --targets '>= 0.25%' themes/$theme.css -o out/readthezero-theme-$theme.css
      cp setup/readthezero.setup.template out/readthezero-$theme.setup
      substituteInPlace out/readthezero-$theme.setup \
        --replace-fail '@THEME@' "$theme" \
        --replace-fail '@VERSION@' "${finalAttrs.version}"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp out/* $out/
    runHook postInstall
  '';

  meta = {
    description = "Modern, accessible HTML export theme for Org-mode";
    homepage = "https://github.com/takeokunn/readthezero";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.all;
  };
})
