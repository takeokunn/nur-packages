{ stdenv
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation (finalAttrs: {
  version = "main";
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
  };
})
