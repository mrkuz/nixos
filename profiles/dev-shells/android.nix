{ pkgs }:

{
  name = "android";
  fhs = false;
  targetPkgs = with pkgs; [
    gitRepo
    scrcpy
  ];
}
