# Description

Builds a Docker image with minimal Java runtime.

```shell
nix build
podman load < result
podman run --rm -ti mrkuz/java
```
