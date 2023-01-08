#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/lib/common.sh"

./update.sh
./update-vscode-extensions.sh
./update-idea-plugins.sh
