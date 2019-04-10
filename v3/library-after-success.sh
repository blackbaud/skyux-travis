#!/usr/bin/env bash
set -e

# Users who can release
SKYUX_TEAM=(
  BLACKBAUD-ALEXKINGMAN
  BLACKBAUD-BOBBYEARL
  BLACKBAUD-PAULCROWDER
  BLACKBAUD-STEVEBRUSH
  BLACKBAUD-TERRYHELEMS
  BLACKBAUD-TREVORBURCH
)

# Necessary to stop pull requests from forks from running.
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" ]]; then

  # Save any new baseline screenshots.
  if [ -d "./node_modules/@skyux-sdk/builder" ]; then
    output=$(node ./node_modules/@skyux-sdk/builder-config/scripts/visual-baselines.js) || exit
  else
    output=$(node ./node_modules/@blackbaud/skyux-builder-config/scripts/visual-baselines.js) || exit
  fi

  # Only run releases during a git tag build.
  if [[ -n "$TRAVIS_TAG" ]]; then

    # Install the TravisCI CLI so we can easily make API calls.
    gem install travis

    # Read the uppercase GitHub username that initiated the build.
    CREATED_BY=$(travis raw /v3/build/$TRAVIS_BUILD_ID --json --skip-completion-check | jq -r '.created_by.login' | tr 'a-z' 'A-Z' )

    # The spaces here are extremely important as they stop false positives.
    # For example, without them, "user" would match "username".
    if [[ " ${SKYUX_TEAM[@]} " =~ " ${CREATED_BY} " ]]; then
      echo -e "${CREATED_BY} has permission to release."

      # Allow package.json to specify a custom build script.
      if npm run | grep -q build:ci; then
        echo -e "Running custom build step... `npm run build:ci`";
        npm run build:ci
      else
        skyux build-public-library
      fi

      cd dist
      bash <(curl -s https://blackbaud.github.io/skyux-travis/after-success.sh)

    else
      echo -e "${CREATED_BY} lacks permission to release.  Please contact the SKY UX team."
    fi
  else
    echo -e "Aborting release. Releases are published after git tag builds only."
  fi
else
  echo -e "Ignoring script. Pull requests from forks are run elsewhere."
fi
