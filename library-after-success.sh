#!/usr/bin/env bash
set -e

echo -e "Blackbaud - SKY UX Travis - Library After Success"

# Necessary to stop pull requests from forks from running outside of Savage
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then
  # Build and publish to NPM.
  skyux build-public-library
  cd dist
  bash <(curl -s https://blackbaud.github.io/skyux-travis/after-success.sh)
else
  echo -e "Ignoring Script"
fi
