#!/usr/bin/env bash
set -e

echo -e "Blackbaud - SKY UX Travis - After Success"

function publish {
  echo -e "Publishing to NPM..."
  npm publish --access public
  echo -e "Successfully published to NPM.\n"
}

# Necessary to stop pull requests from forks from running outside of Savage
# Publish a tag to NPM
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then
  if [[ $NPM_TOKEN ]]; then

    echo -e "Logging in via NPM_TOKEN"
    echo "//registry.npmjs.org/:_authToken=\${NPM_TOKEN}" > .npmrc
    publish
    echo -e "Logging out via NPM_TOKEN"
    rm .npmrc

  elif [[ $NPM_PASSWORD ]]; then

    echo -e "Logging in via NPM_PASSWORD"
    echo -e "blackbaud\n$NPM_PASSWORD\nsky-savage@blackbaud.com" | npm login
    publish
    echo -e "Logging out via NPM_PASSWORD"
    npm logout

  else
    echo -e "Unable to publish to NPM as no credentials are not available"
  fi
else
  echo -e "Ignoring Script"
fi