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
    gnutar
    gptfdisk
    gzip
    iproute2
    iptables
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
  ];

  firmware = super.linkFarm "lxd-firmware" [
    {
      name = "share/OVMF/OVMF_CODE.fd";
      path = "${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.fd";
      path = "${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.ms.fd";
      path = "${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
  ];

  LXD_OVMF_PATH = "${firmware}/share/OVMF";
in
{
  lxd = super.lxd.overrideAttrs (old: {
    doCheck = false;
    postInstall = ''
      wrapProgram $out/bin/lxd --prefix PATH : ${super.lib.makeBinPath binPath} --set LXD_OVMF_PATH ${LXD_OVMF_PATH}
      installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
    '';
  });
}
