#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/../_shared.sh"

export DIGITALOCEAN_ACCESS_TOKEN=$(get_tf_output do_token)

JUMP_SERVER_ADDRESS=$(get_tf_output jump_server_address)
JUMP_SERVER_DROPLET_NAME=$(get_tf_output jump_server_droplet_name)
JUMP_SERVER_VOLUME_PATH=$(get_tf_output jump_server_volume_path)
DATABASE_URL=$(get_tf_output database_url)
SSH_KEY=$(get_tf_output jump_server_ssh_key_path)

function scp_to_host() {
  scp -i $SSH_KEY "$1" "root@$JUMP_SERVER_ADDRESS:$2"
}

function create_jump_env() {
  printf "export DATABASE_URL=$DATABASE_URL\n" > .env.jump
}

create_jump_env
scp_to_host ./.env.jump "$JUMP_SERVER_VOLUME_PATH/.env"
rm ./.env.jump

doctl compute ssh $JUMP_SERVER_DROPLET_NAME --ssh-key-path $SSH_KEY