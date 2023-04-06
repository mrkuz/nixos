{ pkgs }:

{
  name = "web";
  fhs = false;
  targetPkgs = with pkgs; [
    hugo
    html-tidy
    nodejs
  ];
}
