#!/usr/bin/env bash
set -e

# ======================================================
# Abort commit if building a pull request
# ======================================================
if [[ "$TRAVIS_EVENT_TYPE" == "pull_request" ]]; then
  exit 0
fi

# ======================================================
# Abort commit if it's a savage branch
# ======================================================
if [[ $TRAVIS_BRANCH =~ $SAVAGE_BRANCH ]]; then
  exit 0
fi

echo -e "Checking for new baseline screenshots...\n"

git config --global user.email "sky-build-user@blackbaud.com"
git config --global user.name "Blackbaud SKY Build User"
git status --short
git add screenshots-baseline/

# ======================================================
# Commit the new images to the master branch
# ======================================================
if ! git diff-index --quiet HEAD --; then
  git stash save
  git checkout $TRAVIS_BRANCH --quiet
  git stash pop
  git add screenshots-baseline/
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed new visual baseline screenshots [ci skip]"
  git push -fq origin $TRAVIS_BRANCH > /dev/null
  echo -e "Visual baseline screenshots successfully updated.\n"
else
  echo -e "No new baseline screenshots found.\n"
fi
