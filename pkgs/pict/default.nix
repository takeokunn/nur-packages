{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "3.7.4";
  pname = "pict";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "pict";
    rev = "7d2ed98c28b837d8337976b7cbf421bd3c4b89dd";
    hash = "sha256-sG/Kv5JL6h0YYXmr7F5dVtjgAPzEkQCtqS+ZpcUnOxw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Pairwise Independent Combinatorial Tool";
    homepage = "https://www.pairwise.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "pict";
  };
})
