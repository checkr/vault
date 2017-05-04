#!/bin/bash

set -ex

for i in "$@"
do
  case $i in
    -r=*|--redirect-url=*)
      VAULT_REDIRECT_ADDR="${i#*=}"
      shift # past argument=value
      ;;
    *)
      # unknown option
      ;;
  esac
done

sed -i ${VAULT_CONFIG} \
  -e "s|%%AWS_REGION%%|${AWS_REGION}|" \
  -e "s|%%AWS_DYNAMODB_TABLE%%|${AWS_DYNAMODB_TABLE}|" \
  -e "s|%%VAULT_REDIRECT_ADDR%%|${VAULT_REDIRECT_ADDR}|" \
  -e "s|%%VAULT_CLUSTER_ADDR%%|${VAULT_CLUESTER_ADDR}|" \
  -e "s|%%TLS_DISABLE%%|${TLS_DISABLE}|" \
  -e "s|%%TLS_CERT_FILE%%|${TLS_CERT_FILE}|" \
  -e "s|%%TLS_KEY_FILE%%|${TLS_KEY_FILE}|"

_term() { 
  echo "Caught SIGTERM signal!" 
  kill "$child"
}

trap _term SIGTERM

# Run a command in the background.
_evalBg() {
    eval "$@" &>/dev/null &disown;
}

cmd="./bin/overlord.sh";
_evalBg "${cmd}";

vault server -config=${VAULT_CONFIG} &

child=$! 
wait "$child"
