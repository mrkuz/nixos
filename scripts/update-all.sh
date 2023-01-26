#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

./scripts/update.sh
./scripts/update-vscode-extensions.sh
./scripts/update-idea-plugins.sh
