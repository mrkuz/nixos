{ stdenv, pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "jdk11-shell" ''
    export PATH="${pkgs.jdk11}/bin:$PATH"
    export JAVA_HOME="${pkgs.jdk11}"
    export NIX_SHELL="jdk11"
    exec ${pkgs.fish}/bin/fish
  '';
in stdenv.mkDerivation rec {
  name = "jdk11-shell";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/jdk11-shell $out/bin/
  '';
}
