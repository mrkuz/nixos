{ pkgs, ...}:

let
  sources = import ../../../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.black-formatter) name publisher version sha256;
  };
}
