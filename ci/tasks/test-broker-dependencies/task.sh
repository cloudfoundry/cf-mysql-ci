#!/usr/bin/env bash

set -eux

gem install bundler-audit
bundle-audit update

cd cf-mysql-release/src/cf-mysql-broker

bundle-audit
