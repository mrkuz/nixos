#!/usr/bin/env bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 PLUGIN_ID"
  exit 1;
fi

plugin_id=$1
name=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id" | jq -r '.name')
version=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=2" | jq -r '[.[] | select(.version | contains("SNAPSHOT") | not)] | .[0].version')
version_code=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=2" | jq -r '[.[] | select(.version | contains("SNAPSHOT") | not)] | .[0].id')
file=$(curl -s "https://plugins.jetbrains.com/api/plugins/$plugin_id/updates?size=2" | jq -r '[.[] | select(.version | contains("SNAPSHOT") | not)] | .[0].file')

file_name=${file##*/}
file_name=${file_name%.*}
file_name=${file_name/-$version/}

niv add "idea:${name,,}" -v "$version" \
    -s name="$name" \
    -s file_name="$file_name" \
    -s plugin_id="$plugin_id" \
    -s version_code="$version_code" \
    -t "https://plugins.jetbrains.com/files/<plugin_id>/<version_code>/<file_name>-<version>.zip"
