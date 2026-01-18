{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "runn";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "runn";
    rev = "6ea63ce636bfdac75f17d72fe58d01260b01e992";
    hash = "sha256-ytS4sVKjqO3CDlo062GN662fED+OwToSNMBsE0hvcsk=";
  };
  vendorHash = "sha256-46oh76nOW02qNRjqkibUaoAdpYKVeHUj5N5hW5Z1yHs=";
  ldflags = [ "-X=main.Version=${version}" ];

  doCheck = false;

  meta = {
    description = "runn is a package/tool for running operations following a scenario.";
    homepage = "https://github.com/k1LoW/runn";
    mainProgram = "runn";
  };
}
