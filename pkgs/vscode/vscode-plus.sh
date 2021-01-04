#!/usr/bin/env bash

for i in "@out@/share/extensions"/*; do
  cache="/tmp/cache/vscode/`basename $i`"
  [ -d "$cache" ] || mkdir -p "$cache"
done

exec "@vscode@/bin/code" --user-data-dir "$HOME/@userDataDir@" --extensions-dir "@out@/share/extensions" "$@"
