{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../../profiles/users/nixos.nix
  ];

  home.packages = with pkgs; [
    gcompris
  ];
}
