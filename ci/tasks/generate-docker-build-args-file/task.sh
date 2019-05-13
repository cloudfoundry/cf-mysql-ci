#!/bin/bash
set -ex

if [[ -d "bbl-github-release" ]]; then
  BBL_GIT_TAG=`cat bbl-github-release/tag`
fi

BBL6_GIT_TAG="v6.10.44"

if [[ -d "bosh-cli-github-release" ]]; then
  BOSH_CLI_VERSION=`cat bosh-cli-github-release/version`
fi

if [[ -d "credhub-cli-github-release" ]]; then
  CREDHUB_CLI_VERSION=`cat credhub-cli-github-release/version`
fi

if [[ -d "terraform-github-release" ]]; then
  TERRAFORM_VERSION=`cat terraform-github-release/version | tr -d v`
fi

cat << EOF > docker-build-args/docker-build-args.json
{
  "BBL_GIT_TAG": "${BBL_GIT_TAG}",
  "BBL6_GIT_TAG": "${BBL6_GIT_TAG}",
  "BOSH_CLI_VERSION": "${BOSH_CLI_VERSION}",
  "CREDHUB_CLI_VERSION": "${CREDHUB_CLI_VERSION}",
  "TERRAFORM_VERSION": "${TERRAFORM_VERSION}"
}
EOF
