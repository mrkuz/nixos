{ self, nixpkgs, inputs }:

system: import nixpkgs {
  inherit system;
  config.allowUnfree = true;
  config.permittedInsecurePackages = [
    # Required for deezer
    "electron-13.6.9"
  ];

  overlays = [
    inputs.nix-alien.overlay
    inputs.emacs-overlay.overlay
    (_: super: self.packages."${system}")
  ] ++ self.utils.attrsToValues self.overlays;
}
