{ pkgs }:

{
  name = "java";
  fhs = false;
  targetPkgs = with pkgs; [
    gradle
    jdk
    maven
  ];
  profile = ''
    export JAVA_HOME="${pkgs.jdk}"
  '';
}
