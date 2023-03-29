{ stdenv, lib, pkgs, sources, ... }:

# see: https://github.com/snapcore/snapd/blob/master/packaging/arch/PKGBUILD
let
  goModule = pkgs.buildGoModule rec {
    name = "snapd";
    src = sources.snapd;
    patches = [
      ./paths.patch
      ./misc.patch
    ];
    vendorSha256 = "aNKH4Gu2H6o1bQSis3u5vUrATJvv5YMluNVHpXUqwUo=";
    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ libseccomp libxfs libcap ];
    excludedPackages = [ "tests/lib/muinstaller" ];
    postConfigure = ''
      ./mkversion.sh ${sources.snapd.branch}
    '';
    postInstall = ''
      mkdir -p $out/share
      cp cmd/VERSION $out/share/
      cp data/info $out/share/
    '';
    doCheck = false;
  };

  script = pkgs.writeShellScript "snapd-confine" ''
    SNAPD_DEBUG=0 /run/wrappers/bin/snapd-confine "$@"
  '';
in
stdenv.mkDerivation rec {
  name = "snapd";
  src = sources.snapd;
  patches = [
    ./paths.patch
    ./confine.patch
  ];

  nativeBuildInputs = with pkgs; [ go autoconf automake pkg-config ];
  buildInputs = with pkgs; [ libxfs glib systemd libcap glibc glibc.static ];

  configurePhase = ''
    runHook preConfigure
    cp ${goModule}/share/VERSION cmd/VERSION
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Generate data files such as real systemd units, dbus service, environment
    # setup helpers out of the available templates
    make -C data \
      BINDIR=${placeholder "out"}/bin \
      LIBEXECDIR=${placeholder "out"}/lib \
      DATADIR=${placeholder "out"}/share \
      APPLICATIONSDIR=${placeholder "out"}/share/applications \
      ENVD=${placeholder "out"}/lib/environment.d \
      DBUSDIR=${placeholder "out"}/share/dbus-1 \
      DBUSSERVICESDIR=${placeholder "out"}/share/dbus-1/services \
      ICON_FOLDER=${placeholder "out"}/share/snapd \
      SYSTEMDUSERUNITDIR=${placeholder "out"}/lib/systemd/user \
      SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system \
      SNAP_MOUNT_DIR=/snap \
      SNAPD_ENVIRONMENT_FILE=/etc/default/snapd

    cd cmd
    autoreconf -i -f
    ./configure \
      --prefix=/ \
      --libexecdir=/lib/snapd \
      --with-snap-mount-dir=/snap \
      --disable-apparmor \
      --enable-nvidia-biarch \
      --enable-merged-usr
    make
    cd ..
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/

    # Install bash completion
    install -Dm644 data/completion/bash/snap "$out/share/bash-completion/completions/snap"
    install -Dm644 data/completion/bash/complete.sh "$out/lib/snapd/complete.sh"
    install -Dm644 data/completion/bash/etelpmoc.sh "$out/lib/snapd/etelpmoc.sh"

    # Install zsh completion
    install -Dm644 data/completion/zsh/_snap "$out/share/zsh/site-functions/_snap"

    # Install systemd units, dbus services and a script for environment variables
    make -C data/ install \
      BINDIR=/bin \
      LIBEXECDIR=/lib \
      DATADIR=/share \
      APPLICATIONSDIR=/share/applications \
      ENVD=/lib/environment.d \
      DBUSDIR=/share/dbus-1 \
      DBUSSERVICESDIR=/share/dbus-1/services \
      ICON_FOLDER=/share/snapd \
      SYSTEMDUSERUNITDIR=/lib/systemd/user \
      SYSTEMDSYSTEMUNITDIR=/lib/systemd/system \
      SNAP_MOUNT_DIR=/snap \
      DESTDIR="$out"

    # Install polkit policy
    install -Dm644 data/polkit/io.snapcraft.snapd.policy "$out/share/polkit-1/actions/io.snapcraft.snapd.policy"

    # Install executables
    install -Dm755 "${goModule}/bin/snap" "$out/bin/snap"
    install -Dm755 "${goModule}/bin/snapctl" "$out/lib/snapd/snapctl"
    install -Dm755 "${goModule}/bin/snapd" "$out/lib/snapd/snapd"
    install -Dm755 "${goModule}/bin/snap-seccomp" "$out/lib/snapd/snap-seccomp"
    install -Dm755 "${goModule}/bin/snap-failure" "$out/lib/snapd/snap-failure"
    install -Dm755 "${goModule}/bin/snap-update-ns" "$out/lib/snapd/snap-update-ns"
    install -Dm755 "${goModule}/bin/snap-exec" "$out/lib/snapd/snap-exec"

    # Ensure /bin/snapctl is a symlink to /usr/libexec/snapd/snapctl
    ln -s $out/lib/snapd/snapctl "$out/bin/snapctl"

    substituteInPlace cmd/Makefile --replace " 4755 " " 755 "
    substituteInPlace cmd/Makefile --replace " 111 " " 755 "

    make -C cmd install \
      SYSTEMD_SYSTEM_GENERATOR_DIR=/lib/systemd/system-generators \
      SYSTEMD_SYSTEM_ENV_GENERATOR_DIR="/lib/systemd/system-environment-generators" \
      DESTDIR="$out"

    # Install man file
    mkdir -p "$out/share/man/man8"
    "$out/bin/snap" help --man > "$out/share/man/man8/snap.8"

    # Install the "info" data file with snapd version
    install -m 644 -D ${goModule}/share/info "$out/lib/snapd/info"

    # Remove snappy core specific units
    rm -fv "$out/lib/systemd/system/snapd.system-shutdown.service"
    rm -fv "$out/lib/systemd/system/snapd.autoimport.service"
    rm -fv "$out/lib/systemd/system/snapd.recovery-chooser-trigger.service"
    rm -fv "$out"/lib/systemd/system/snapd.snap-repair.*
    rm -fv "$out"/lib/systemd/system/snapd.core-fixup.*
    # and scripts
    rm -fv "$out/lib/snapd/snapd.core-fixup.sh"
    rm -fv "$out/bin/ubuntu-core-launcher"
    rm -fv "$out/lib/snapd/system-shutdown"

    # Remove prompt services
    rm -fv "$out/lib/systemd/system/snapd.aa-prompt-listener.service"
    rm -fv "$out/lib/systemd/user/snapd.aa-prompt-ui.service"
    rm -fv "$out/share/dbus-1/services/io.snapcraft.Prompt.service"

    # Remove apparmor stuff
    rm -fv "$out/lib/systemd/system/snapd.apparmor.service"
    rmdir -v "$out/var/lib/snapd/apparmor/snap-confine/"
    rmdir -v "$out/var/lib/snapd/apparmor/"

    # Set up for security wrapper
    mv "$out/lib/snapd/snap-confine" "$out/lib/snapd/snap-confine.unwrapped"
    cp ${script} "$out/lib/snapd/snap-confine"

    runHook postInstall
  '';
}
