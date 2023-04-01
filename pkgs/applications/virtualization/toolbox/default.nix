{ stdenv, lib, pkgs, sources, ... }:



let
  goModule = pkgs.buildGoModule rec {
    name = "toolbox-modules";
    src = "${sources.toolbox}/src";
    vendorSha256 = sources.toolbox.vendorSha256;
    buildInputs = with pkgs; [ shadow ];
    overrideModAttrs = (_: {
      patches = [ ./versions.patch ];
    });
    patches = [
      ./nix-store.patch
      ./versions.patch
    ];
    doCheck = false;
  };
  libraryPath = lib.makeLibraryPath (with pkgs; [ shadow ]);
in
stdenv.mkDerivation rec {
  name = "toolbox";
  src = sources.toolbox;

  nativeBuildInputs = with pkgs; [ meson cmake go go-md2man pkg-config ninja podman makeWrapper ];
  buildInputs = with pkgs; [ shadow fish bash-completion systemd binutils ];

  mesonFlags = [
    "-Dtmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dprofile_dir=${placeholder "out"}/share/profile.d"
  ];

  preConfigure = ''
    sed -i "/subdir('src')/d" meson.build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    meson install --no-rebuild

    makeWrapper ${goModule}/bin/toolbox $out/bin/toolbox --prefix LD_LIBRARY_PATH : ${libraryPath}
    rm -rfv $out/share/toolbox/test/

    # mkdir -p $out/share/bash-completion/completions/
    # $out/bin/toolbox completion bash > $out/share/bash-completion/completions/toolbox.bash
    # mkdir -p $out/share/fish/vendor_completions.d/
    # $out/bin/toolbox completion fish > $out/share/fish/vendor_completions.d/toolbox.fish
    # mkdir -p $out/share/zsh/site-functions/
    # $out/bin/toolbox completion zsh > $out/share/zsh/site-functions/_toolbox

    runHook postInstall
  '';
}
