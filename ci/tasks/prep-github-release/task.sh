#!/usr/bin/env bash

set -eux

WORKSPACE_DIR=$PWD

cp ${WORKSPACE_DIR}/release-notes/RELEASE_NOTES_v* "${WORKSPACE_DIR}/output-release-dir/generated-release-notes"
echo "v$(cat ${WORKSPACE_DIR}/version/version)" > "${WORKSPACE_DIR}/output-release-dir/release-tag"

pushd "${WORKSPACE_DIR}/${RELEASE_DIR}-committed/${RELEASE_DIR}-final"
  git rev-parse HEAD > "${WORKSPACE_DIR}/output-release-dir/git-commit"
popd
