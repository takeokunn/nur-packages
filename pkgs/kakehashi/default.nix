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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "kakehashi";
    rev = "refs/tags/v${version}";
    hash = "sha256-DIXI3hjBx/Xdu5oA06Mf+Zg3/H/htP3lzacj6DI4WuI=";
  };

  cargoHash = "sha256-cmdkJTOdsSApfpbQsbtHdWKxz8Wy22tT/j+v/lwtDLk=";

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
