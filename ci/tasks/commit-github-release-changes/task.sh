#!/usr/bin/env bash

set -eux


GIT_COMMIT_MESSAGE="${GIT_COMMIT_MESSAGE:?}"

if [ -f "${GIT_COMMIT_MESSAGE}" ]
then
  GIT_COMMIT_MESSAGE=$(cat "${GIT_COMMIT_MESSAGE}")
fi

pushd github-release

  git config --global user.email "core-services-bot@pivotal.io"
  git config --global user.name "Final Release Builder"

  git add -A .

  if ! git diff-index --quiet HEAD; then
    git commit -m "${GIT_COMMIT_MESSAGE}"
  fi

popd

cp -rf github-release/. github-release-committed
