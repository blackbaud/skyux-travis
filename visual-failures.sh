#!/usr/bin/env bash

# Fail the build if this step fails
set -e

# This file only runs if there are results from the visualtests
# It's using the deploy key specified in Travis since Secure Environemnt Variables aren't available to forks.

if [[ "$(ls -A skyux-spa-visual-tests/screenshots-diff)" ]]; then

  echo -e "Starting to update webdriver test results.\n"

  git config --global user.email "sky-build-user@blackbaud.com"
  git config --global user.name "Blackbaud Sky Build User"
  git clone --quiet https://${GH_TOKEN}@github.com/blackbaud/skyux-visualtest-results.git skyux-visualtest-results-webdriver > /dev/null

  cd skyux-visualtest-results-webdriver

  branch="skyux-lib-$TRAVIS_BUILD_ID-webdriver"

  if [[ $TRAVIS_BRANCH =~ $SAVAGE_BRANCH ]]; then
    branch="$branch-savage"
  fi

  git checkout -b $branch
  cp -rf ../screenshots-created/ created-screenshots/
  mkdir -p failures
  cp -rf ../screenshots-diff/ failures/
  mkdir -p all
  cp -rf ../screenshots-baseline/ all/

  git add -A
  if [ -z "$(git status --porcelain)" ]; then
    echo -e "No new screenshots found."
  else
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER webdriver screenshot results pushed to skyux-visualtest-results"
    git push -fq origin $branch > /dev/null
    echo "New screenshots successfully committed.\n"
    echo -e "Test results may be viewed at https://github.com/blackbaud/skyux-visualtest-results/tree/$branch"
  fi
fi
