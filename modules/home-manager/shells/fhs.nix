{ pkgs }:

{
  name = "fhs";
  fhs = true;
  targetPkgs = with pkgs; [ pkgs.zlib ];
}
