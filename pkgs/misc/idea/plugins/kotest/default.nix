{ stdenv, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "kotest";
  src = sources."idea:kotest";

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
