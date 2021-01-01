{ pkgs, ...}:

let
  sources = import ../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.sonarlint-vscode) name publisher version sha256;
  };
}
