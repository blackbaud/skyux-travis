#!/usr/bin/env bash
set -e

# Necessary to stop pull requests from forks from running.
if [ "$TRAVIS_SECURE_ENV_VARS" == "true" ]; then
  npm install -g blackbaud/skyux-sdk-cli#trust-linux-remove-argv
  skyux version
  skyux certs install
else
  echo -e "Ignoring script. Pull requests from forks are run elsewhere."
fi
