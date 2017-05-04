#!/bin/bash

[[ ${DEBUG} == 'true' ]] && set -x

sed -i ${VAULT_CONFIG} \
  -e "s|%%AWS_REGION%%|${AWS_REGION}|" \
  -e "s|%%AWS_DYNAMODB_TABLE%%|${AWS_DYNAMODB_TABLE}|" \
  -e "s|%%TLS_DISABLE%%|${TLS_DISABLE}|" \
  -e "s|%%TLS_CERT_FILE%%|${TLS_CERT_FILE}|" \
  -e "s|%%TLS_KEY_FILE%%|${TLS_KEY_FILE}|"

# Run a command in the background.
_evalBg() {
    eval "$@" &>/dev/null &disown;
}

cmd="./bin/overlord.sh";
_evalBg "${cmd}";

vault server -config=${VAULT_CONFIG}
