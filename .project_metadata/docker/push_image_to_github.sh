#!/usr/bin/env bash
# bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# setting up environment variables
source ./.project_metadata/docker/common_environment_variables.sh

# login to github docker repository
cat ~/.ssh/037_personal_terraform_infra.txt | docker login https://docker.pkg.github.com -u abrahamvarricatt --password-stdin
# upload the image!
docker push docker.pkg.github.com/abrahamvarricatt/personal_terraform_infra/circle_base_image:$PR_IMAGE_VERSION

