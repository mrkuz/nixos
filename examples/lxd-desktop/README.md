# Description

Builds a LXD VM image with XFCE.

```shell
nix build
./result/bin/import-image

lxc launch nixos nixos --ephemeral --vm --console=vga -c security.secureboot=false
```
