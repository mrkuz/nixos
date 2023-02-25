{ pkgs }:

{
  name = "web";
  fhs = false;
  targetPkgs = with pkgs; [ nodejs ];
}
