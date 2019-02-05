#!/usr/bin/env bash

set -eux

cp release-notes/RELEASE_NOTES_v* output-release-dir/generated-release-notes
echo "v$(cat version/version)" > output-release-dir/release-tag

git -C github-release-committed rev-parse HEAD > output-release-dir/git-commit
