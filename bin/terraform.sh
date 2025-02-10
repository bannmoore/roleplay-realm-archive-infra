#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd ./terraform
terraform "${@:-plan}" -var-file="secret.tfvars"