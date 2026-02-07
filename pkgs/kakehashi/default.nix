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
}:

rustPlatform.buildRustPackage rec {
  pname = "kakehashi";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "kakehashi";
    rev = "refs/tags/v${version}";
    hash = "sha256-3rYhInb/Po33pphc9SoQhrwOR/UZZSnLab01tLUOiXs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-M8V3doU6gv6yKbwbJPQeimq9/1K2u6V1+PphVvy4iN8=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    libiconv
  ];

  doCheck = false;

  meta = {
    description = "A Tree-sitter based Language Server bridging multiple language servers";
    homepage = "https://github.com/atusy/kakehashi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "kakehashi";
  };
}
