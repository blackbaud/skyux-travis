# Fail the build if this step fails
set -e

# Necessary to stop pull requests from forks from running outside of Savage
# Publish a tag to NPM
if [[ "$TRAVIS_SECURE_ENV_VARS" == "true" && -n "$TRAVIS_TAG" ]]; then
  echo -e "blackbaud\n$NPM_PASSWORD\nsky-savage@blackbaud.com" | npm login
  npm publish --access public
  npm logout
  echo -e "Successfully published to NPM.\n"
fi
