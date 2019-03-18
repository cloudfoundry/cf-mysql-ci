#!/usr/bin/env bash

set -euo pipefail

BREAKING_CHANGE_VERSION="250.16" # This is the version at which the bosh.io site broke the url convention

stemcell_version="$(bosh int "cf-deployment-rc/cf-deployment.yml" --path=/stemcells/os=ubuntu-xenial/version)"


function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

if version_gt $stemcell_version $BREAKING_CHANGE_VERSION; then
  aria2c -x 4 -d cf-deployment-rc-stemcell \
    https://s3.amazonaws.com/bosh-core-stemcells/${stemcell_version}/bosh-stemcell-${stemcell_version}-google-kvm-ubuntu-xenial-go_agent.tgz
else
  aria2c -x 4 -d cf-deployment-rc-stemcell \
    https://s3.amazonaws.com/bosh-core-stemcells/google/bosh-stemcell-${stemcell_version}-google-kvm-ubuntu-xenial-go_agent.tgz
fi

# the compile release script expects a version file in the stemcell folder
echo ${stemcell_version} > cf-deployment-rc-stemcell/version
