#!/usr/bin/env bash
set -e

# http://blog.500tech.com/setting-up-travis-ci-to-run-tests-on-latest-google-chrome-version/
sh -e /etc/init.d/xvfb start
sudo apt-get update
sudo apt-get install -y libappindicator1 fonts-liberation
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
rm google-chrome*.deb

npm install -g @blackbaud/skyux-cli
