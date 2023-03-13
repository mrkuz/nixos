{ self, nixpkgs, inputs }:

system: import nixpkgs {
  inherit system;
  config.allowUnfree = true;
  overlays = [
    inputs.nix-alien.overlay
    inputs.emacs-overlay.overlay
    # inputs.nixpkgs-wayland.overlay
    (_: super: self.packages."${system}")
  ] ++ self.utils.attrsToValues self.overlays;
}
