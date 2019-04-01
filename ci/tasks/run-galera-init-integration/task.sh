#!/bin/bash
set -euo pipefail

trap "killall --signal KILL mysqld; service docker stop" EXIT

service docker start

while ! docker info > /dev/null; do
  sleep 2
done

echo "Pulling docker image: percona/percona-xtradb-cluster:5.7"
time docker pull percona/percona-xtradb-cluster:5.7

if [[ ! -d /sys/fs/cgroup/systemd ]]; then
  # Fix for issue where container creation fails: https://github.com/moby/moby/issues/36016
  mkdir /sys/fs/cgroup/systemd
  mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
fi

pushd pxc-release
  source .envrc
  ./scripts/test-integration
popd
