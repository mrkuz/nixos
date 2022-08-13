{ pkgs, inputs, vars, ... }:

{
  imports = [
    ../_all/home.nix
  ];

  home.packages = with pkgs; [
    gcompris
  ];
}
