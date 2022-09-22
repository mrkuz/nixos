{ stdenv, pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "graalvm-shell" ''
    export PATH="${pkgs.graalvm11-ce}/bin:$PATH"
    export JAVA_HOME="${pkgs.graalvm11-ce}"
    export GRAALVM_HOME="${pkgs.graalvm11-ce}"
    export NIX_SHELL="graalvm"
    exec ${pkgs.fish}/bin/fish
  '';
in
stdenv.mkDerivation rec {
  name = "graalvm-shell";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/graalvm-shell $out/bin/
  '';
}
