{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "isucrud";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "mazrean";
    repo = "isucrud";
    rev = "refs/tags/v${version}";
    hash = "sha256-FBNJ8JDMUTLeSbd9gtZkQevn5dnbOf5RX6BzK5j32N8=";
  };
  vendorHash = "sha256-hVgvjuZwRwYFul4dWZnY1uiU5roWN9qOpV3gJStLT/I=";
  ldflags = [ "-X=main.Version=${version}" ];
  meta = {
    description = "ISUCON用DBへのCRUDへのデータフロー可視化ツール";
    homepage = "https://github.com/mazrean/isucrud";
    mainProgram = "isucrud";
  };
}
