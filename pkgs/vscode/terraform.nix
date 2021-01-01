{ pkgs, ...}:

let
  sources = import ../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.terraform) name publisher version sha256;
  };
}
