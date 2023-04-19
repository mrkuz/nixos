# Description

Builds Docker image.

```shell
nix build
podman import result/tarball/nixos-system-x86_64-linux.tar.xz nixos
podman run --rm -t --name nixos --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro nixos /init

# Other terminal
podman exec -ti nixos /run/current-system/sw/bin/bash
```
