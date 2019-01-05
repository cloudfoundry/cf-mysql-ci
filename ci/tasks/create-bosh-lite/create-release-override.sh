#!/bin/bash

set -eu

source "$(pwd)/cf-mysql-ci/scripts/utils.sh"

override_for_release () {
  RELEASE_TARBALL_DIR="$1"
  export RELEASE_TARBALL_DIR

  RELEASE_FILE=$(ls ${RELEASE_TARBALL_DIR}/ | grep "tgz")
  export RELEASE_FILE

  name=$(release_name)
  version=$(release_version)

  url="file://${RELEASE_TARBALL_DIR}/${RELEASE_FILE}"

  cat << EOF
---
- type: replace
  path: /releases/name=${name}/version
  value: ${version}
- type: replace
  path: /releases/name=${name}/url
  value: ${url}
EOF
}
