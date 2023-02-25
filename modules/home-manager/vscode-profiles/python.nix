{ sources }:

let
  baseExtensions = import ./base-extensions.nix { inherit sources; };
in
{
  name = "Python";
  alias = "pcode";
  extensions = baseExtensions ++ [
    sources."vscode:python"
    sources."vscode:isort" # dependency for python
    sources."vscode:vscode-pylance" # dependency for python
    sources."vscode:jupyter" # dependency for python
    sources."vscode:jupyter-keymap" # dependency for jupyter
    sources."vscode:jupyter-renderers" # dependency for jupyter
    sources."vscode:black-formatter"
    sources."vscode:vscode-jupyter-cell-tags" # dependency for jupyter
    sources."vscode:vscode-jupyter-slideshow" # dependency for jupyter
  ];
}
