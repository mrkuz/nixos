{ pkgs, ...}:

let
  sources = import ../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.vscode-kubernetes-tools) name publisher version sha256;
  };
}
