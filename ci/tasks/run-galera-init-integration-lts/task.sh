#!/bin/bash
set -euo pipefail

trap "pkill -9 mysqld;" EXIT

rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql

cat > /tmp/init.sql <<EOF
CREATE USER 'root'@'127.0.0.1';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
EOF

mysqld --initialize-insecure \
       --init-file=/tmp/init.sql > mysqld_initialize.log 2>&1
mysqld --character-set-server=utf8 \
       --collation-server=utf8_unicode_ci \
       --daemonize \
       --log-error=/tmp/mysqld.log

pushd pxc-release
    source .envrc
    ginkgo -r -slowSpecThreshold=180 \
           -race \
           -failOnPending \
           -randomizeAllSpecs \
           src/github.com/cloudfoundry/galera-init/integration_test/
popd
