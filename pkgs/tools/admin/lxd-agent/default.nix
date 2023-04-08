{ stdenv, lib, pkgs, sources, ... }:

pkgs.buildGoPackage rec {
  name = "lxd-agent";
  version = "5.12";
  src = pkgs.lxd.src;

  goPackagePath = "github.com/lxc/lxd";
  ldflags = [ "-s" "-w" "-extldflags '-static'" ];
  subPackages = [ "lxd-agent" ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';
}
