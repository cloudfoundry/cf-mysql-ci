#!/usr/bin/env bash

set -eu

workspace_dir="$(pwd)"
source "${workspace_dir}/cf-mysql-ci/scripts/utils.sh"

bosh_release_version="$(cat "${workspace_dir}/last-pxc-release-bosh-release/version")"
pushd "${workspace_dir}/last-pxc-release-source"
  github_release_version="$(git tag -l --points-at HEAD | cut -c 2-)"
popd
if [ "$bosh_release_version" != "$github_release_version" ]; then
  err "Fetched mismatched last pxc release version"
  err "bosh.io release version: $bosh_release_version"
  err "github release version: $github_release_version"
  exit 1
fi
