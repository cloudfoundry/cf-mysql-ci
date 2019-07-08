#!/bin/bash

set -eux

WORKSPACE_DIR="$(pwd)"
RELEASE_DIR="${WORKSPACE_DIR}/$RELEASE_DIR"
ci_repo_dir="${WORKSPACE_DIR}/cf-mysql-ci"

source "${ci_repo_dir}/scripts/utils.sh"

: "${ENV_TARGET_FILE:?}"

options=""

BOSH_ENVIRONMENT="$(cat "${ENV_TARGET_FILE}")"
BOSH_ENVIRONMENT="$(sslip_from_ip "${BOSH_ENVIRONMENT}")"
export BOSH_ENVIRONMENT

BOSH_CLIENT=${BOSH_CLIENT:-"$(jq_val "bosh_user" "${ENV_METADATA}")"}
export BOSH_CLIENT

BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET:-"$(jq_val "bosh_password" "${ENV_METADATA}")"}
export BOSH_CLIENT_SECRET

BOSH_CA_CERT=`cat $BOSH_CA_CERT_PATH`
export BOSH_CA_CERT

BOSH_DEPLOYMENT=${BOSH_DEPLOYMENT:-"${DEPLOYMENT_NAME}"}
export BOSH_DEPLOYMENT

pushd $RELEASE_DIR
    bosh create-release --force --timestamp-version
    bosh upload-release
    ./scripts/deploy
popd
