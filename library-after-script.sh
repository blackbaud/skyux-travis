#!/usr/bin/env bash
set -e

# Necessary to stop pull requests from forks from running outside of Savage
if [ "$TRAVIS_SECURE_ENV_VARS" == "true" ]; then
  # Publish code coverage results.
  bash <(curl -s https://codecov.io/bash)

  # Kill any BrowserStack processes.
  bash <(curl -s https://blackbaud.github.io/skyux-travis/browserstack-cleanup.sh)

  # Commits screenshots to the same repo.
  bash <(curl -s https://blackbaud.github.io/skyux-travis/visual-baseline.sh)
fi
