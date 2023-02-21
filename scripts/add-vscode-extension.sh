#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

if [ $# -ne 1 ]; then
  echo "Usage: $0 EXTENSION"
  exit 1;
fi

function get_details {
  curl -s -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
    --header 'accept: application/json;api-version=7.1-preview.1' \
    --header 'content-type: application/json' \
    --data-raw "{
      \"filters\": [{
        \"criteria\": [{
          \"filterType\": 8,
          \"value\": \"Microsoft.VisualStudio.Code\"
        }, {
          \"filterType\": 7,
          \"value\": \"$1\"
        }],
        \"pageNumber\": 1,
        \"pageSize\": 1
      }],
      \"flags\": 16
    }"
}

publisher=${1%%.*}
name=${1##*.}
version=$(get_details $1 | jq -r '.results[0].extensions[0].versions[] | select(.properties | index({ "key": "Microsoft.VisualStudio.Code.PreRelease", "value" : "true" }) | not) | .version' | head -n1)

niv add "vscode:$name" -a name=$name -a publisher=$publisher -v $version -t "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<name>/<version>/vspackage?targetPlatform=linux-x64"
