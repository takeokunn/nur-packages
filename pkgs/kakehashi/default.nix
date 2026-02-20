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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "kakehashi";
    rev = "refs/tags/v${version}";
    hash = "sha256-E7jx7yAfAkWBF4lR6yShfOqOfSA3KAQZiMY3yrdcDyg=";
  };

  cargoHash = "sha256-FXVubZqjaCT2Ufkar6Ttfqg5s5BwO5Zxv5UyirMrGLE=";

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
