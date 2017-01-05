#!/usr/bin/env bash
set -e

echo -e "Blackbaud - SKY UX Travis - After Success"

# Necessary to stop pull requests from forks from running outside of Savage
# Publish a tag to NPM
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then
  echo -e "Logging in to NPM..."
  echo -e "TEST: $NPM_PASSWORD"
  echo -e "blackbaud\n$NPM_PASSWORD\nsky-savage@blackbaud.com" | npm login --verbose
  echo -e "Publishing to NPM..."
  npm publish --access public
  echo -e "Logging out of NPM..."
  npm logout
  echo -e "Successfully published to NPM.\n"
else
  echo -c "Ignoring Script"
fi
