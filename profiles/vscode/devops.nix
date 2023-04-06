{ sources }:

let
  baseExtensions = import ./base-extensions.nix { inherit sources; };
in
{
  name = "DevOps";
  alias = "dcode";
  extensions = baseExtensions ++ [
    sources."vscode:aws-toolkit-vscode"
    sources."vscode:nix"
    sources."vscode:terraform"
    sources."vscode:vscode-docker"
    sources."vscode:vscode-kubernetes-tools"
    sources."vscode:vscode-yaml" # dependency for vscode-docker, vscode-kubernetes-tools
  ];
}
