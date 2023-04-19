# Description

Builds Docker image with XFCE desktop environment.

```shell
nix build
podman import result/tarball/nixos-system-x86_64-linux.tar.xz nixos
podman run --rm -t --name nixos --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 3389:3389 nixos /init

# Other terminal
remmina -c rdp://localhost:3389
```
