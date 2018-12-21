#!/usr/bin/env bash
set -eu

workspace_dir="$(pwd)"

source "cf-mysql-ci/scripts/utils.sh"

credhub_login
mysql_host=$(cat bosh-lite-info/external-ip)
mysql_pass=$(credhub_value /lite/cf/cf_mysql_mysql_admin_password)

mysql -uroot -p${mysql_pass} -h ${mysql_host} -e "show global variables like '%wsrep_provider_options%';" | \
  grep 'socket.ssl = YES; socket.ssl_ca = /var/vcap/jobs/pxc-mysql/certificates/galera-ca.pem; socket.ssl_cert = /var/vcap/jobs/pxc-mysql/certificates/galera-cert.pem'
