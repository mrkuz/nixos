# Cheat sheet

## Show GC roots

``` shell
nix-store --gc --print-roots | grep -v "{censored}" | column -t | sort -k3 -k1
```

## List all packages

``` shell
nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq
```

## Find biggest packages

``` shell
nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n10
```

## Find biggest closures (packages including dependencies)

``` shell
nix path-info -hSr /run/current-system/ | sort -hrk2 | head -n10
```

## Show package dependencies as tree

``` shell
nix-store -q --tree $(realpath $(which htop))
```

## Show package dependencies including size

``` shell
nix path-info -hSr nixpkgs#htop
```
