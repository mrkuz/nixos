{ stdenv, lib, pkgs, sources, name, targetPkgs, profile ? "", ... }:

let
  fullName = "${name}-shell";
  env = pkgs.buildEnv {
    name = fullName;
    paths = targetPkgs;
  };
  script = pkgs.writeShellScriptBin "${fullName}" ''
    export NIX_SHELL="${name}"
    export PATH=${env}/bin:$PATH
    ${profile}
    exec ${pkgs.fish}/bin/fish
  '';
in
stdenv.mkDerivation rec {
  name = fullName;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script}/bin/${fullName} $out/bin/
  '';
}
