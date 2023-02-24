{ pkgs }:

{
  name = "android";
  fhs = false;
  targetPkgs = with pkgs; [
    android-file-transfer
    gitRepo
    scrcpy
  ];
}
