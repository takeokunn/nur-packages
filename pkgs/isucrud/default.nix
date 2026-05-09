{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "isucrud";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "mazrean";
    repo = "isucrud";
    rev = "refs/tags/v${version}";
    hash = "sha256-wO2KZY6yc+CvghL5gyUgzMbfEjrXtFQ8Nn80AE8ueew=";
  };
  vendorHash = "sha256-o54/el1ofJd60uN5BRCz1f4Ha7n+/emdr27YOfx7Nj8=";
  ldflags = [ "-X=main.Version=${version}" ];
  meta = {
    description = "Data flow visualization tool for CRUD operations on ISUCON databases";
    homepage = "https://github.com/mazrean/isucrud";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    platforms = lib.platforms.unix;
    mainProgram = "isucrud";
  };
}
