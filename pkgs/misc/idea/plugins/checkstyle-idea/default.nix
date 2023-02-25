{ stdenv, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "checkstyle-idea";
  src = sources."idea:checkstyle-idea";

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
