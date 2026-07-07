{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  openssl,
  apple-sdk_15,
  libiconv,
  makeWrapper,
  tree-sitter,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakehashi";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "kakehashi";
    rev = "refs/tags/v${version}";
    hash = "sha256-PKx/YN8f4zUjJJR/3xlgSWv2wEa0zuafuzCv/rVJKdg=";
  };

  cargoHash = "sha256-S37r+OA5x/K4zlZ+tql1b8oc0dhj/dhDMg6Kq8URMds=";

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    libiconv
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/kakehashi \
      --prefix PATH : ${lib.makeBinPath [ tree-sitter ]}
  '';

  meta = {
    description = "A Tree-sitter based Language Server bridging multiple language servers";
    homepage = "https://github.com/atusy/kakehashi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "kakehashi";
  };
}
