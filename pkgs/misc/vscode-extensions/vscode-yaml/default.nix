{ pkgs, ...}:

let
  sources = import ../../../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.vscode-yaml) name publisher version sha256;
  };
}
