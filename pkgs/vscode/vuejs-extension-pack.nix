{ pkgs, ...}:

let
  sources = import ../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.vuejs-extension-pack) name publisher version sha256;
  };
}
