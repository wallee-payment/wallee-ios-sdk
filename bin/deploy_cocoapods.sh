#!/usr/bin/env bash

if [ -z "${TRAVIS_TAG}" ];
then
  echo "[INFO] This is not tagged build. Skipping deployment to cocoapods.";
elif [ "$TRAVIS_PULL_REQUEST" != "false" ];
then
  echo "This is pull request. Skipping deployment to cocoapods."
else
  echo "[INFO] Publishing artifacts to cocoapods."
  source ~/.rvm/scripts/rvm
	rvm use default
  pod lib lint
  pod trunk push
fi

