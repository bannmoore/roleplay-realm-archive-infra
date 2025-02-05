#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "${BASH_SOURCE[0]}")"

function get_tf_output() {
  cd ../terraform
  terraform output -json "$1" | jq -r .
}

function scp_to_host() {
  scp -i ~/.ssh/id_rsa_do "$1" "root@$(get_tf_output postgres_jump_box_addr):$2"
}

function scp_from_host() {
  scp -i ~/.ssh/id_rsa_do "root@$(get_tf_output postgres_jump_box_addr):$1" "$2"
}

function create_jump_env() {
  printf "DATABASE_URL=$(get_tf_output postgres_url)\n" > jump.env
}

create_jump_env
scp_to_host ./setup.sh "~/setup.sh"
scp_to_host ./jump.env "~/.env"