#!/usr/bin/env bash
# bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Setting up common environment variables

export PR_IMAGE_VERSION="3.0"
