{ pkgs, ...}:

let
  sources = import ../../../../nix/sources.nix;
in pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources.markdown-preview-github-styles) name publisher version sha256;
  };
}