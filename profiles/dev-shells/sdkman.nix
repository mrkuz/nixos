{ pkgs }:

{
  name = "sdkman";
  fhs = true;
  targetPkgs = with pkgs; [ zlib ];
  profile = ''
    export SDKMAN_DIR=$HOME/opt/sdkman
    source $SDKMAN_DIR/bin/sdkman-init.sh
  '';
}
