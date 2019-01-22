#!/bin/bash

set -eux

WORKSPACE_DIR="$(pwd)"
source "./cf-mysql-ci/scripts/utils.sh"

credhub_login

export BOSH_ENVIRONMENT=$(cat bosh-lite-info/external-ip)
export MYSQL_PASSWORD=$(credhub_value /lite/pxc/cf_mysql_mysql_admin_password)

pushd ./cf-mysql-ci/scripts/test-data
  echo "Inserting test data..."

  mysql --host=${BOSH_ENVIRONMENT} \
    --user=root \
    --password=${MYSQL_PASSWORD} \
    < clean-bosh-lite-test-database.sql

  mysql --host=${BOSH_ENVIRONMENT} \
    --user=root \
    --password=${MYSQL_PASSWORD} \
    mysql_persistence_test \
    < insert-test-data.sql
popd

echo "Successfully inserted test data"
