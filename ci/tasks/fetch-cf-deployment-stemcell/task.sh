#!/usr/bin/env bash

set -euo pipefail

stemcell_version="$(bosh int "cf-deployment-rc/cf-deployment.yml" --path=/stemcells/os=ubuntu-xenial/version)"

aria2c -x 4 -d cf-deployment-rc-stemcell \
  https://s3.amazonaws.com/bosh-core-stemcells/google/bosh-stemcell-${stemcell_version}-google-kvm-ubuntu-xenial-go_agent.tgz

# the compile release script expects a version file in the stemcell folder
echo ${stemcell_version} > cf-deployment-rc-stemcell/version
