#!/usr/bin/env bash

set -eux

workspace_dir="$(pwd)"
output_dir="${workspace_dir}/cf-mysql-vars"

source "cf-mysql-ci/scripts/utils.sh"

credhub_login

env_domain=$(bosh int environment/metadata --path /domain)

cat << EOF > "${output_dir}/cf-mysql-vars.yml"
---
cf_admin_password: "$(cf_admin_password)"
cf_admin_username: "admin"
proxy_vm_extension: "mysql-proxy-lb"
cf_skip_ssl_validation: true
cf_api_url: "https://api.${env_domain}"
app_domains: "[${env_domain}]"
cf_mysql_external_host: "p-mysql.${env_domain}"
cf_mysql_host: "proxy-p-mysql.${env_domain}"
EOF
