{ pkgs, ... }:

{
  imports = [
    ../_all/home.nix
  ];

  home.packages = with pkgs; [
    firefox
  ];
}
