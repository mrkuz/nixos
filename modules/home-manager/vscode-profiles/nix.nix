let
  sources = import ../../../nix/sources.nix;
  baseExtensions = import ./base-extensions.nix;
in {
  name = "Nix";
  alias = "ncode";
  extensions = baseExtensions ++ [
    sources."vscode:nix-ide"
  ];
}
