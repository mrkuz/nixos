{ stdenv, glib, ... }:

let
  sources = import ../../../../../nix/sources.nix;
in stdenv.mkDerivation rec {
  name = "gnome-shell-shortcuts";
  src = sources.shortcuts-gnome-extension;
  uuid = "Shortcuts@kyle.aims.ac.za";

  buildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    echo 'Compiling translations...'
    for po in locale/*/LC_MESSAGES/*.po; do
        msgfmt -cv -o "$\\{po%.po}.mo" $po;
    done
    if [ -d src/schemas ]; then
        echo 'Compiling preferences...'
        glib-compile-schemas --targetdir=src/schemas src/schemas
    else
        echo 'No preferences to compile... Skipping'
    fi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r src/* locale $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
