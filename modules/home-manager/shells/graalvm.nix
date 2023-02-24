{ pkgs }:

{
  name = "graalvm";
  fhs = false;
  targetPkgs = with pkgs; [ graalvm11-ce ];
  profile = ''
    export JAVA_HOME="${pkgs.graalvm11-ce}"
    export GRAALVM_HOME="${pkgs.graalvm11-ce}"
  '';
}
