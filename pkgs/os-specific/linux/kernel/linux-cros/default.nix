{ stdenv, pkgs, lib, sources, ... }:

let
  source = stdenv.mkDerivation rec {
    name = "linux-cros-source";
    version = sources.linux-cros.version;
    src = sources.linux-cros;

    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      tar -xzf $src -C $out/
      runHook postInstall
    '';
  };
in
pkgs.linuxKernel.manualConfig rec {
  version = source.version;
  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;
  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = source;

  # Created with:
  # - CHROMEOS_KERNEL_FAMILY=termina ./chromeos/scripts/prepareconfig container-vm-x86_64
  # - make olddefconfig
  # - make kvm_guest.config
  # - make menuconfig
  # Enable:
  # - CONFIG_OVERLAY_FS
  # - CONFIG_CRYPTO_USER_API_HASH
  # - CONFIG_AUTOFS4_FS
  # - CONFIG_BLK_DEV_INITRD
  # Disable:
  # - CONFIG_SECURITY_CHROMIUMOS
  configfile = ./config;
  allowImportFromDerivation = true;
}
