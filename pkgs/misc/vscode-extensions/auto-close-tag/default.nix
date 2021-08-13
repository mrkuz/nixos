{ pkgs, ...}:

let
  sources = import ../../../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.auto-close-tag) name publisher version sha256;
  };
}
