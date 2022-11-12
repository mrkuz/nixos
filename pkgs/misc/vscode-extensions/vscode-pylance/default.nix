{ pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
in
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    inherit (sources."vscode:vscode-pylance") name publisher version sha256;
  };
}
