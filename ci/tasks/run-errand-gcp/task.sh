#!/bin/bash

set -eux

WORKSPACE_DIR="$(pwd)"
ci_dir="cf-mysql-ci"
source "${ci_dir}/scripts/utils.sh"

: "${ENV_METADATA:?}"
: "${ERRAND:?}"

BOSH_ENVIRONMENT=$(jq_val "target" "${ENV_METADATA}")
export BOSH_ENVIRONMENT

BOSH_CLIENT=${BOSH_CLIENT:-"$(jq_val "client" "${ENV_METADATA}")"}
export BOSH_CLIENT

BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET:-"$(jq_val "client_secret" "${ENV_METADATA}")"}
export BOSH_CLIENT_SECRET

BOSH_CA_CERT=$(jq_val "ca_cert" "${ENV_METADATA}")
export BOSH_CA_CERT

bosh \
    -n \
    run-errand \
    ${ERRAND}

