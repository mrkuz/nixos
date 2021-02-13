#!/usr/bin/env bash

extensions=$(jq '.[] | select(.url | length > 0)  | select(.url | test("marketplace.visualstudio")) | .name' nix/sources.json)

for ext in $extensions; do
  echo "Updating $ext..."
  url=$(jq -r ".$ext | .url" nix/sources.json)
  hash=$(nix-prefetch-url --type sha256 "$url")
  jq --indent 4 ".$ext.sha256 = \"$hash\"" nix/sources.json > nix/sources.new.json
  mv nix/sources.new.json nix/sources.json
  sleep 10
done;
