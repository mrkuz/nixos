{ stdenv, lib, pkgs, sources, ... }:

pkgs.buildGoModule rec {
  name = "lxd-agent";
  src = pkgs.lxd-unwrapped.src;
  vendorHash = null;

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];
  modRoot = "./lxd-agent";

  postConfigure = ''
    export CGO_ENABLED=0
  '';
}
