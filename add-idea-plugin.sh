#!/usr/bin/env bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 PLUGIN_ID"
  exit 1;
fi

plugin_id=$1
name=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id" | jq -r '.name')
# link=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id" | jq -r '.link')

file=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=1" | jq -r '.[0].file')
version=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=1" | jq -r '.[0].version')
# version_code=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=1" | jq -r '.[0].id')

niv add "idea:${name,,}" -v $version -a file=$file -t "https://plugins.jetbrains.com/files/<file>"
# alternative: https://plugins.jetbrains.com/files/<plugin-id>/<version-code>/<name>-<version>.zip
