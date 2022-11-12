{ pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources."vscode:jupyter-keymap") name publisher version sha256;
  };
}
