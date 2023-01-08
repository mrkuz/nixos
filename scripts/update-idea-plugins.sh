#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

plugins=$(jq -r '.[] | select(.url | length > 0)  | select(.url | test("plugins.jetbrains.com")) | .name' nix/sources.json)

for plugin in $plugins; do
  plugin=${plugin,,}
  echo "Updating $plugin..."
  plugin_id=$(jq -r ".\"idea:$plugin\" | .plugin_id" nix/sources.json)
  version=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=2" | jq -r '[.[] | select(.version | contains("SNAPSHOT") | not)] | .[0].version')
  version_code=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=2" | jq -r '[.[] | select(.version | contains("SNAPSHOT") | not)] | .[0].id')
  niv update "idea:$plugin" -v "$version" -s version_code="$version_code"
  sleep 1
done;
