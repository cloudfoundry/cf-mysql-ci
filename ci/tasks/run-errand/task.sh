#!/bin/bash

set -eux

WORKSPACE_DIR="$(pwd)"
ci_repo_dir="${WORKSPACE_DIR}/cf-mysql-ci"
bosh_lite_info_dir="${WORKSPACE_DIR}/bosh-lite-info"

source "${ci_repo_dir}/scripts/utils.sh"

: "${ENV_TARGET_FILE:?}"
: "${ERRAND:?}"
: "${INSTANCE:=}"

options=""

if [[ ! -z "${INSTANCE}" ]]; then
  options="--instance=${INSTANCE}"
fi

source ${bosh_lite_info_dir}/source_me

bosh \
    -n \
    run-errand \
    ${options} \
    ${ERRAND}
