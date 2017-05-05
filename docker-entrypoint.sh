#!/bin/bash

set -e

export OVERLORD_DAEMON=${OVERLORD_DAEMON:=true}
export VAULT_CONFIG=${VAULT_CONFIG:=/vault/vault.hcl}
export VAULT_SKIP_VERIFY=${VAULT_SKIP_VERIFY:=false}
export TLS_DISABLE=${TLS_DISABLE:=1}
export TLS_CERT_FILE=${TLS_CERT_FILE:=/vault/certs/cert.pem}
export TLS_KEY_FILE=${TLS_KEY_FILE:=/vault/certs/key.pem}
export RECOVERY_MODE=${RECOVERY_MODE:=1}
export VAULT_ADMIN_PASSWORD=${VAULT_ADMIN_PASSWORD:=""}
export VAULT_UNSEAL_KEY=${VAULT_UNSEAL_KEY:-""}
export AWS_REGION=${AWS_REGION:-"us-east-1"}
export AWS_DYNAMODB_TABLE=${AWS_DYNAMODB_TABLE:-"vault-data"}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-""}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-""}
export VAULT_REDIRECT_ADDR=${VAULT_REDIRECT_ADDR:-""}

if [[ ${TLS_DISABLE} == '0' ]]; then
  export VAULT_ADDR='https://0.0.0.0:8200'
else
  export VAULT_ADDR='http://0.0.0.0:8200'
fi

exec "$@"
