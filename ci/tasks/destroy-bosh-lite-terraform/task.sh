#!/bin/bash
set -eu

pushd ./${DEPLOYMENTS_DIR}/bosh-lite-gcp
  terraform destroy -force
popd
