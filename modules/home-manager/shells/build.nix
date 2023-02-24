{ pkgs }:

{
  name = "build";
  fhs = false;
  targetPkgs = with pkgs; [
    cmake
    gcc
    gnumake
  ];
}
