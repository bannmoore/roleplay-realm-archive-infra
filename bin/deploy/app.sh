#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

(
  cd "$(dirname "${BASH_SOURCE[0]}")/../../docker"

  doctl auth init
  doctl registry login --expiry-seconds 86400

  docker compose build app
  docker push registry.digitalocean.com/bam/roleplay-realm-archive

  doctl registry logout
)