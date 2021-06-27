{ stdenv, pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "jdk8-shell" ''
    export PATH="${pkgs.jdk8}/bin:$PATH"
    export JAVA_HOME="${pkgs.jdk8}"
    export JAVA_8_HOME="${pkgs.jdk8}"
    export NIX_SHELL="jdk8"
    exec ${pkgs.fish}/bin/fish
  '';
in stdenv.mkDerivation rec {
  name = "jdk8-shell";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/jdk8-shell $out/bin/
  '';
}
