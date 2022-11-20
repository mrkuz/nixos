{ stdenv, pkgs, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in
stdenv.mkDerivation rec {
  name = "mybatisx";
  src = sources."idea:mybatisx";

  buildInputs = with pkgs; [ unzip ];

  unpackPhase = ''
    unzip -o $src
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/JetBrains/plugins/${name}
    cp -r */* $out/share/JetBrains/plugins/${name}
    runHook postInstall
  '';
}
