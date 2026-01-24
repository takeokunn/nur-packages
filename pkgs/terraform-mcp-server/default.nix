{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "terraform-mcp-server";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-mcp-server";
    rev = "222a5b93fc0b7714889f5381fd1f3ef0cb7fabb8";
    hash = "sha256-9EsULRhqXttn4vSayOOTCpvX6ZjJygjWx5OQJrEC43E=";
  };
  vendorHash = "sha256-lW5XIaY5NAn3sSDJExMd1i/dueb4p1Uc4Qpr4xsgmfE=";

  doCheck = false;

  meta = {
    description = "The Terraform MCP Server provides seamless integration with Terraform ecosystem, enabling advanced automation and interaction capabilities for Infrastructure as Code (IaC) development.";
    homepage = "https://github.com/hashicorp/terraform-mcp-server";
    mainProgram = "terraform-mcp-server";
  };
}
