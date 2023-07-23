self: super:
# see: https://github.com/NixOS/nixpkgs/pull/166858
let
  pkgs = self;
  binPath = with pkgs; [
    acl
    attr
    bash
    btrfs-progs
    criu
    dnsmasq
    e2fsprogs
    gnutar
    gptfdisk
    gzip
    iproute2
    iptables
    kmod
    lvm2
    lxd-agent
    nftables
    qemu-utils
    qemu_kvm
    rsync
    squashfsTools
    util-linux
    xz
    (super.writeShellScriptBin "apparmor_parser" ''
      exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
    '')
    (super.runCommandLocal "virtfs-proxy-helper" { } ''
      mkdir -p $out/bin/
      ln -s ${pkgs.qemu_kvm}/libexec/virtfs-proxy-helper "$out/bin/virtfs-proxy-helper"
    '')
  ];

  ovmfUbuntu = super.stdenv.mkDerivation rec {
    pname = "ovmf-ubuntu";
    version = "2022.05-4";

    src = super.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/e/edk2/ovmf_${version}_all.deb";
      sha256 = "ONuX/Iij769tWyIOvY7AzaFpqG8P0Bv/pn3i7Q1JXW0=";
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    dontStrip = true;
    unpackPhase = "dpkg -x $src ./";
    installPhase = ''
      mkdir -p $out/share/OVMF
      cp ./usr/share/OVMF/OVMF_CODE.fd $out/share/OVMF/
      cp ./usr/share/OVMF/OVMF_VARS.fd $out/share/OVMF/
      cp ./usr/share/OVMF/OVMF_VARS.ms.fd $out/share/OVMF/
    '';
  };

  LXD_OVMF_PATH = "${ovmfUbuntu}/share/OVMF";
in
{
  lxd = super.lxd-unwrapped.overrideAttrs (old: {
    doCheck = false;
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/lxd --prefix PATH : ${super.lib.makeBinPath binPath} --set LXD_OVMF_PATH ${LXD_OVMF_PATH}
      installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
    '';
  });
}
