#!/usr/bin/env bash

extensions=$(jq -r '.[] | select(.url | length > 0)  | select(.url | test("marketplace.visualstudio")) | .name' nix/sources.json)

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

for ext in $extensions; do
  fqn=$(jq -r ".\"vscode:$ext\" | .publisher + \".\" + .name" nix/sources.json)
  echo "Updating $fqn..."
  version=$(get_details $fqn | jq -r '.results[0].extensions[0].versions[] | select(.properties | index({ "key": "Microsoft.VisualStudio.Code.PreRelease", "value" : "true" }) | not) | .version' | head -n1)
  niv update "vscode:$ext" -v $version
  sleep 1
done;
