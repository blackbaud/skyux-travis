#!/usr/bin/env bash
set -e

# Necessary to stop pull requests from forks from running.
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" ]]; then

  echo -e "Must not be PR since TRAVIS_SECURE_ENV_VARS is set to true."

  # Save any new baseline screenshots.
  if [ -d "./node_modules/@skyux-sdk/builder" ]; then
    echo -e "Running @skyux-sdk/builder-config visual baselines..."
    output=$(node ./node_modules/@skyux-sdk/builder-config/scripts/visual-baselines.js) || exit
  else
    echo -e "Running @blackbaud/skyux-builder-config visual baselines..."
    output=$(node ./node_modules/@blackbaud/skyux-builder-config/scripts/visual-baselines.js) || exit
  fi

  echo -e "Visual baseline output:"
  echo $output

  # Only run releases during a git tag build.
  if [[ -n "$TRAVIS_TAG" ]]; then

    echo -e "Processing git tag build..."

    # Allow package.json to specify a custom build script.
    if npm run | grep -q build:ci; then
      echo -e "Running custom build step... `npm run build:ci`";
      npm run build:ci
    else
      skyux build-public-library
    fi

    echo -e "Executing skyux-travis/after-success..."
    cd dist
    bash <(curl -s https://blackbaud.github.io/skyux-travis/after-success.sh)
  else
    echo -e "Aborting release. Releases are published after git tag builds only."
  fi
else
  echo -e "Ignoring script. Pull requests from forks are run elsewhere."
fi
