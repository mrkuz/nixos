# Description

Builds a simple Docker image from Nix expression.

```shell
nix build
podman load < result
podman run --rm -ti hello-docker
```
