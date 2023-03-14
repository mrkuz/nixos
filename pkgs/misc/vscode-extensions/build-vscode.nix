{ stdenv, lib, pkgs, sources, name, userDataDir, extensions, ... }:

with lib;

let
  makeVsix = source:
    let fileName = removePrefix "/nix/store/" source;
    in "$NIX_BUILD_TOP/${fileName}.vsix";
  makeLink = source:
    let vsix = makeVsix source;
    in "ln -s \"${source}\" \"${vsix}\"";
  makeInstall = source:
    let vsix = makeVsix source;
    in "${pkgs.vscode}/bin/code --user-data-dir \"$NIX_BUILD_TOP/user-data\" --extensions-dir \"$out/share/$name/extensions\" --install-extension \"${vsix}\"";
in
stdenv.mkDerivation {
  inherit name;
  src = ./.;

  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/{bin,share/$name/extensions}

    ${concatMapStringsSep "\n" (makeLink) extensions}
    ${concatMapStringsSep "\n" (makeInstall) extensions}

    for i in "$out/share/$name/extensions"/*; do
      if [ -d "$i" ]; then
        [ -d "$i/cache" ] && rm -rf "$i/cache"
        ln -svf "/tmp/cache/vscode/`basename $i`" "$i/cache"
      fi
    done

    substitute ./build-vscode.sh "$out/bin/${name}" \
      --subst-var-by name $name \
      --subst-var-by out $out \
      --subst-var-by vscode ${pkgs.vscode} \
      --subst-var-by userDataDir ${userDataDir}
    chmod 755 "$out/bin/${name}"
  '';
}
