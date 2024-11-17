{
  pkgs ? import <nixpkgs> {},
  buildGoModule,
  fetchFromGitHub
}:
buildGoModule rec {
  pname = "tcardgen";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "Ladicle";
    repo = "tcardgen";
    rev = "2222547ac37c2d6e1961b00acef3771f48ac8220";
    hash = "sha256-6Z4SWpjdPMMCC6xm+xjSNAWQpO2FD91p+Mk9Y+Hh7AY=";
  };
  vendorHash = "sha256-+lG2MlilOsHTqs31zvwVMu9DoNBY6ZPrqzJkVXHWYak=";
  ldflags = [ "-X=main.Version=${version}" ];

  buildInputs = with pkgs; [ go_1_23 ];

  doCheck = false;

  meta = {
    description = "Generate a TwitterCard(OGP) image for your Hugo posts.";
    homepage = "https://github.com/Ladicle/tcardgen";
    mainProgram = "tcardgen";
  };
}
