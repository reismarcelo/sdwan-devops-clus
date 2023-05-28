#!/usr/bin/env bash
IMAGE=${IMAGE:-ghcr.io/ciscodevnet/sdwan-devops:cloud}
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
   "CONFIG_BUILDER_METADATA"
   )

for OPTION in ${OPTION_LIST[*]}; do
   if [[ ! -z "${!OPTION}" ]]; then
      OPTIONS="$OPTIONS --env $OPTION=${!OPTION}"
   fi
done

OPTIONS="$OPTIONS --env ANSIBLE_ROLES_PATH=/ansible/roles --env ANSIBLE_STDOUT_CALLBACK=debug"


if [[ ! -z "$VIRL_HOST" ]]; then
   OPTIONS="$OPTIONS --env =$VIRL_HOST"
fi
if [[ ! -z "$VIRL_USERNAME" ]]; then
   OPTIONS="$OPTIONS --env VIRL_USERNAME=$VIRL_USERNAME"
fi
if [[ ! -z "$VIRL_PASSWORD" ]]; then
   OPTIONS="$OPTIONS --env VIRL_PASSWORD=$VIRL_PASSWORD"
fi
if [[ ! -z "$VIRL_LAB" ]]; then
   OPTIONS="$OPTIONS --env VIRL_LAB=$VIRL_LAB"
fi
if [[ ! -z "$VMANAGE_HOST" ]]; then
   OPTIONS="$OPTIONS --env VMANAGE_HOST=$VMANAGE_HOST"
fi
if [[ ! -z "$VMANAGE_ORG" ]]; then
   OPTIONS="$OPTIONS --env VMANAGE_ORG=$VMANAGE_ORG"
fi
if [[ ! -z "$VMANAGE_USERNAME" ]]; then
   OPTIONS="$OPTIONS --env VMANAGE_SESSION=$VMANAGE_USERNAME"
fi
if [[ ! -z "$VMANAGE_PASSWORD" ]]; then
   OPTIONS="$OPTIONS --env VIRL_SESSION=$VMANAGE_PASSWORD"
fi

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
