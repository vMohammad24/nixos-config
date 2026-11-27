{
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-for-blender";
  version = "2.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "mcp_for_blender";
    inherit version;
    hash = "sha256-CUyq3roNmk0XC5ON37M3t0rjnKDdKq24K/tvuTyL7Cc=";
  };

  build-system = [python3Packages.setuptools];
  dependencies = [
    python3Packages.mcp_1
    python3Packages.httpx
  ];

  pythonImportsCheck = ["blender_mcp"];

  meta = {
    description = "MCP server for Blender";
    homepage = "https://github.com/ahujasid/mcp-for-blender";
    license = lib.licenses.mit;
    mainProgram = "mcp-for-blender";
  };
}
