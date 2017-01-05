#!/usr/bin/env bash
set -e +o pipefail

echo -e "
 888888ba  dP                   dP       dP                               dP 
 88    `8b 88                   88       88                               88 
a88aaaa8P' 88 .d8888b. .d8888b. 88  .dP  88d888b. .d8888b. dP    dP .d888b88 
 88   `8b. 88 88'  `88 88'  `"" 88888"   88'  `88 88'  `88 88    88 88'  `88 
 88    .88 88 88.  .88 88.  ... 88  `8b. 88.  .88 88.  .88 88.  .88 88.  .88 
 88888888P dP `88888P8 `88888P' dP   `YP 88Y8888' `88888P8 `88888P' `88888P8 
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
"

# Necessary to stop pull requests from forks from running outside of Savage
# Publish a tag to NPM
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then
  echo -e "blackbaud\n$NPM_PASSWORD\nsky-savage@blackbaud.com" | npm login
  npm publish --access public
  npm logout
  echo -e "Successfully published to NPM.\n"
fi
