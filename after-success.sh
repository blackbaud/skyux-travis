#!/usr/bin/env bash
set -e

# Users who can release
SKYUX_TEAM=(
  BLACKBAUD-ALEXKINGMAN
  BLACKBAUD-BENLAMBERT
  BLACKBAUD-BOBBYEARL
  BLACKBAUD-BRANDONJONES
  BLACKBAUD-PAULCROWDER
  BLACKBAUD-STEVEBRUSH
  BLACKBAUD-TERRYHELEMS
  BLACKBAUD-TIMPEPPER
  BLACKBAUD-TREVORBURCH
)

echo -e "Blackbaud - SKY UX Travis - After Success"

function publish {
  echo -e "Publishing to NPM..."
  npm publish --access public
  echo -e "Successfully published to NPM.\n"
  
  url="https://github.com/$TRAVIS_REPO_SLUG"

  # Create a message, linking to CHANGELOG.md if it exists
  if [[ -e "CHANGELOG.md" ]]; then
    url="$url/blob/master/CHANGELOG.md"
  fi

  notifySlack "$TRAVIS_REPO_SLUG \`$TRAVIS_TAG\` published to NPM.\n$url"
}

notifySlack() {
  if [[ -n $SLACK_WEBHOOK ]]; then
    echo -e "Notifying Slack."
    curl -X POST --data-urlencode 'payload={"text":"'"$1"'"}' $SLACK_WEBHOOK
  else
    echo -e "No webhook available for Slack notification."
  fi
}

# Necessary to stop pull requests from forks from running outside of Savage
# Publish a tag to NPM
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then

  # Install the TravisCI CLI so we can easily make API calls.
  gem install travis

  # Read the uppercase GitHub username that initiated the build.
  CREATED_BY=$(travis raw /v3/build/$TRAVIS_BUILD_ID --json --skip-completion-check | jq -r '.created_by.login' | tr 'a-z' 'A-Z' )

  # The spaces here are extremely important as they stop false positives.
  # For example, without them, "user" would match "username".
  if [[ " ${SKYUX_TEAM[@]} " =~ " ${CREATED_BY} " ]]; then

    echo -e "${CREATED_BY} has permission to release."

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
    echo -e "${CREATED_BY} lacks permission to release.  Please contact the SKY UX team."
  fi

else
  echo -e "Ignoring Script"
fi