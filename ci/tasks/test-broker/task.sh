#!/bin/bash
set -eux

mysqld_safe &
MYSQLD_PID=$!

pushd cf-mysql-release/src/cf-mysql-broker
  rm -rf vendor
  bundle install --deployment --without development
  bundle exec rake db:create db:migrate

  mysql -uroot -e "set global innodb_stats_on_metadata=ON"
  mysql -uroot -e "set global innodb_stats_persistent=OFF"
  bundle exec rspec spec
popd

kill -9 "${MYSQLD_PID}"
