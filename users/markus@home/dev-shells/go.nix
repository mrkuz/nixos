{ pkgs }:

{
  name = "go";
  fhs = false;
  targetPkgs = with pkgs; [ go ];
}
