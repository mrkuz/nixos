{ stdenv, pkgs, sources, ... }:

stdenv.mkDerivation rec {
  name = "revealjs";
  src = sources.revealjs;

  unpackPhase = ''
    runHook preUnpack
    tar xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/
    cp -r reveal.js-${src.version} $out/opt/reveal.js
    runHook postInstall
  '';
}
