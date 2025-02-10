#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function get_tf_output() {
  cd ./terraform
  terraform output -json "$1" | jq -r .
}

export DIGITALOCEAN_ACCESS_TOKEN=$(get_tf_output do_token)

(
  cd docker
  docker compose build web

  doctl registry login
  docker push registry.digitalocean.com/bam/roleplay-realm-archive
)