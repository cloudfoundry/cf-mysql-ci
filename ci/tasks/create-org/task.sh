#!/bin/bash

set -eux

workspace_dir=$(pwd)
ci_dir="${workspace_dir}/cf-mysql-ci/"

source ${ci_dir}/scripts/utils.sh

credhub_login

api_url="api.$(cf_domain)"
cf login -a ${api_url} -u $(cf_admin_username) -p $(cf_admin_password) --skip-ssl-validation

cf create-org pipeline-test-org
cf orgs
cf target -o "pipeline-test-org"
