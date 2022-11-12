#!/usr/bin/env bash
if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 EXTENSION <VERSION>"
  exit 1;
fi

publisher=${1%%.*}
name=${1##*.}
version=${2:-latest}

niv add "vscode:$name" -a name=$name -a publisher=$publisher -v $version -t "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<name>/<version>/vspackage"
