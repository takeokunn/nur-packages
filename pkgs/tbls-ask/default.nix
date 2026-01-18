{ buildGo124Module, fetchFromGitHub }:
buildGo124Module {
  pname = "tbls-ask";
  version = "0.6.6";
  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls-ask";
    rev = "4738fb9d9814cb987317d20973c9a0ffcc90e2d2";
    hash = "sha256-BpFFhnbWqJbrqUrnS4C0Oj5XcdDVw6OvSkm67nZp4D8=";
  };
  vendorHash = "sha256-UppBuDm+j7P0YGzEHrw2Fp7NSOmkKP+8BKHd1kgUZmk=";

  doCheck = false;

  meta = {
    description = "tbls-ask is an external subcommand of tbls for asking LLM of the datasource.";
    homepage = "https://github.com/k1LoW/tbls-ask";
    mainProgram = "tbls-ask";
  };
}
