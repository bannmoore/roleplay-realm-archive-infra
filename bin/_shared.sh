#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function get_tf_output() {
  cd "$(dirname "${BASH_SOURCE[0]}")/../terraform"
  terraform output -json "$1" | jq -r .
}