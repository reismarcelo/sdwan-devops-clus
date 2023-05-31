#!/usr/bin/env bash
IMAGE=${IMAGE:-ghcr.io/ciscodevnet/sdwan-devops:cloud}
SASTRE_ROOT_DIR="snapshots"

OPTIONS=""

if [[ ! -z "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
   OPTIONS="--env ANSIBLE_VAULT_PASSWORD_FILE=/tmp/vault.pw -v $ANSIBLE_VAULT_PASSWORD_FILE:/tmp/vault.pw"
fi

OPTION_LIST=( \
   "AWS_ACCESS_KEY_ID" \
   "AWS_SECRET_ACCESS_KEY" \
   "AWS_SESSION_TOKEN" \
   "ARM_CLIENT_ID" \
   "ARM_CLIENT_SECRET" \
   "ARM_SUBSCRIPTION_ID" \
   "ARM_TENANT_ID" \
   "GOOGLE_OAUTH_ACCESS_TOKEN" \
   "GCP_PROJECT" \
   "PROJ_ROOT" \
   "CONFIG_BUILDER_METADATA" \
   "SASTRE_ROOT_DIR" \
   "VMANAGE_IP" \
   "VMANAGE_USER" \
   "VMANAGE_PASSWORD" \
   "VMANAGE_PORT"
   )

for OPTION in ${OPTION_LIST[*]}; do
   if [[ ! -z "${!OPTION}" ]]; then
      OPTIONS="$OPTIONS --env $OPTION=${!OPTION}"
   fi
done

OPTIONS="$OPTIONS --env ANSIBLE_ROLES_PATH=/ansible/roles --env ANSIBLE_STDOUT_CALLBACK=debug"

while getopts ":d" opt; do
  case $opt in
    d)
      docker run -it --rm -v $PWD:/ansible --env PWD="/ansible" --env USER="$USER" $OPTIONS $IMAGE /bin/bash
      exit
      ;;
  esac
done

docker run -it --rm -v $PWD:/ansible \
   --env PWD="/ansible" \
   --env USER="$USER" \
   $OPTIONS \
   $IMAGE ansible-playbook "$@"
