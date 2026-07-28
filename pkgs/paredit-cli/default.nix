{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "paredit-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "takeokunn";
    repo = "paredit-cli";
    rev = "v${version}";
    hash = "sha256-e0tQ050RLNJYl6Kpdp1mqJi5RdYevZlpr757zp6tddw=";
  };

  cargoHash = "sha256-n+JwjeAhq4YZt8eTcIpEw9xe59js495MqapySuGAV4M=";

  meta = {
    description = "Structure-editing CLI for safe S-expression refactoring by AI coding agents";
    homepage = "https://github.com/takeokunn/paredit-cli";
    license = lib.licenses.mit;
    mainProgram = "paredit";
    maintainers = with lib.maintainers; [ takeokunn ];
  };
}
