{ pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources."vscode:vscode-emacs-friendly") name publisher version sha256;
  };
}
