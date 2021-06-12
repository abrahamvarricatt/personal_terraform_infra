#!/usr/bin/env bash
# bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# setting up environment variables
source ./.project_metadata/docker/common_environment_variables.sh

# Build docker image
docker build -f ./.project_metadata/docker/Dockerfile \
    -t docker.pkg.github.com/abrahamvarricatt/personal_terraform_infra/circle_base_image:$PR_IMAGE_VERSION \
    -t circle_base_image \
    .

