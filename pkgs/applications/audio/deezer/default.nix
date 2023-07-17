{ stdenv, lib, pkgs, sources, ... }:

# see:
# - https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=deezer
# - https://github.com/Shawn8901/nix-configuration/blob/main/packages/deezer/default.nix

let
  desktop = pkgs.makeDesktopItem {
    name = "deezer";
    desktopName = "Deezer";
    comment = "Deezer audio streaming service";
    icon = "deezer";
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    type = "Application";
    mimeTypes = [ "x-scheme-handler/deezer" ];
    startupWMClass = "deezer";
    exec = "deezer %u";
    terminal = false;
    startupNotify = true;
  };
in
stdenv.mkDerivation rec {
  name = "deezer";
  src = sources.deezer;

  buildInputs = with pkgs; [
    imagemagick
    makeWrapper
    nodePackages.asar
    nodePackages.prettier
    p7zip
  ];
  patches = [
    ./avoid-change-default-texthtml-mime-type.patch
    ./fix-isDev-usage.patch
    ./quit.patch
    ./remove-kernel-version-from-user-agent.patch
    ./start-hidden-in-tray.patch
    ./systray-buttons-fix.patch
  ];

  unpackPhase = ''
    runHook preUnpack

    # Extract app from installer
    7z x -so $src "\''$PLUGINSDIR/app-32.7z" > app-32.7z
    # Extract app archive
    7z x -y -bsp0 -bso0 app-32.7z

    cd resources/
    asar extract app.asar app

    prettier --write "app/build/*.js"

    substituteInPlace app/build/main.js --replace \
      "return external_path_default().join(process.resourcesPath, appIcon);" \
      "return external_path_default().join('$out', 'share/deezer/', appIcon);"

    cd ..

    runHook postUnpack
  '';

  prePatch = ''
    cd resources/app
  '';

  postPatch = ''
    cd ../..
  '';

  buildPhase = ''
    runHook preBuild

    cd resources/
    convert win/app.ico win/deezer.png
    asar pack app app.asar
    cd ..

    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/deezer/linux"
    mkdir -p "$out/share/applications"
    mkdir -p "$out/bin/"
    for size in 16 32 48 64 128 256; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps/"
    done

    install -Dm644 resources/app.asar "$out/share/deezer/"
    install -Dm644 resources/win/systray.png "$out/share/deezer/linux/"
    install -Dm644 resources/win/deezer-0.png "$out/share/icons/hicolor/16x16/apps/deezer.png"
    install -Dm644 resources/win/deezer-1.png "$out/share/icons/hicolor/32x32/apps/deezer.png"
    install -Dm644 resources/win/deezer-2.png "$out/share/icons/hicolor/48x48/apps/deezer.png"
    install -Dm644 resources/win/deezer-3.png "$out/share/icons/hicolor/64x64/apps/deezer.png"
    install -Dm644 resources/win/deezer-4.png "$out/share/icons/hicolor/128x128/apps/deezer.png"
    install -Dm644 resources/win/deezer-5.png "$out/share/icons/hicolor/256x256/apps/deezer.png"

    install -Dm644 ${desktop}/share/applications/deezer.desktop "$out/share/applications/deezer.desktop"

    makeWrapper ${pkgs.electron_13}/bin/electron $out/bin/deezer \
      --add-flags $out/share/deezer/app.asar \
      --chdir $out/share/deezer

    runHook postInstall
  '';
}
