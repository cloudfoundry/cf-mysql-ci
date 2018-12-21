#!/bin/bash

set -eux

workspace_dir="$(pwd)"

source cf-mysql-ci/scripts/utils.sh
credhub_login

api_url="api.$(cf_domain)"

cf login -a ${api_url} -u $(cf_admin_username) -p $(cf_admin_password) -o pipeline-test-org --skip-ssl-validation

cf logout
