# Description

Builds a crosvm image.

```shell
nix build
./result/bin/start-vm
```

Alternative:

```shell
nix run
```

To run a wayland application inside the VM:

```shell
sudo chmod 666 /dev/wl0
sommelier weston-terminal
sommelier -X --xwayland-path=/run/current-system/sw/bin/Xwayland xeyes
```
