{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "ecspresso";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    rev = "refs/tags/v${version}";
    hash = "sha256-vdyzV4yG1Z/Pti+bnFJ8SUt+1ZDoXAI9rtD6KFJWhls=";
  };

  vendorHash = "sha256-Uo0Cv22aWRC0/q8clgQPiQaog03eYHrhPQMRKoSWmy8=";
  ldflags = [ "-X=main.Version=${version}" ];

  meta = {
    description = "ecspresso is a deployment tool for Amazon ECS";
    homepage = "https://github.com/kayac/ecspresso";
    mainProgram = "ecspresso";
  };
}
