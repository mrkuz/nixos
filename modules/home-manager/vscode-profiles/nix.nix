{ sources }:

let
  baseExtensions = import ./base-extensions.nix { inherit sources; };
in
{
  name = "Nix";
  alias = "ncode";
  extensions = baseExtensions ++ [
    sources."vscode:nix-ide"
  ];
}
