#!/bin/bash

set -eux

tmpdir=$(mktemp -d /tmp/mysql_scaling.XXXXX)
trap '{ rm -rf ${tmpdir}; }' EXIT

WORKSPACE_DIR="$(pwd)"
CI_DIR="${WORKSPACE_DIR}/cf-mysql-ci"
MY_DIR="${CI_DIR}/ci/tasks/test-scaling"

: "${ENV_TARGET_FILE:?}"
: "${BOSH_DEPLOYMENT:?}"
: "${BOSH_CLIENT:?}"
: "${BOSH_CLIENT_SECRET:?}"

export BOSH_ENVIRONMENT="$(cat "${ENV_TARGET_FILE}")"
export BOSH_CA_CERT="${WORKSPACE_DIR}/bosh-lite-info/ca-cert"

source "${MY_DIR}/scaling-helpers-ondemand"

if [[ $SCALE_TO_FULL_TEST == "false" ]]; then
  setup_infrastructure_variables 10.244.7.2 10.244.8.2
else
  setup_infrastructure_variables 10.244.7.2 10.244.8.2 10.244.9.3
fi

pushd "${MY_DIR}"
  bundle install
popd

if [[ $SCALE_TO_FULL_TEST == "false" ]]; then
  scale_down_to_minimal
fi

clear_data
write_some_data 1000

if [[ $SCALE_TO_FULL_TEST == "false" ]]; then
  scale_up_to_default
else
  deploy_full_cluster #this step removes the arbitrator
fi

verify_replicated_row_count_is 1000

scale_down_to_minimal
write_some_data 1000
verify_first_node_row_count_is 2000

echo "Success!"
