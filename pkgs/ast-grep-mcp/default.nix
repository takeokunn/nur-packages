{
  lib,
  python313Packages,
  fetchFromGitHub,
  ast-grep,
}:

python313Packages.buildPythonApplication {
  pname = "ast-grep-mcp";
  version = "0.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep-mcp";
    rev = "732c339c3812a44e9111e6c3aefec64894acd58f";
    hash = "sha256-jsKJRr68MsYUy+3siEag+6WAMXHgGug5xkG0Mq3voas=";
  };

  postPatch = ''
    echo "" >> pyproject.toml
    echo '[build-system]' >> pyproject.toml
    echo 'requires = ["setuptools"]' >> pyproject.toml
    echo 'build-backend = "setuptools.build_meta"' >> pyproject.toml
    echo "" >> pyproject.toml
    echo '[tool.setuptools]' >> pyproject.toml
    echo 'py-modules = ["main"]' >> pyproject.toml
  '';

  build-system = with python313Packages; [ setuptools ];

  dependencies = with python313Packages; [
    pydantic
    pyyaml
    mcp
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ast-grep ]}" ];

  meta = {
    description = "MCP server providing structural code search via ast-grep";
    homepage = "https://github.com/ast-grep/ast-grep-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takeokunn ];
    mainProgram = "ast-grep-server";
    platforms = lib.platforms.unix;
  };
}
