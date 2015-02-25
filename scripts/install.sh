#!/bin/bash

# Dynamic hosts through Pantheon mean constantly checking interactively
# that we mean to connect to an unknown host. We ignore those here.
echo "StrictHostKeyChecking no" > ~/.ssh/config
export TRAVIS_COMMIT_MSG="$(git log --format=%B --no-merges -n 1)"

# Use that as our path
export PATH="$TRAVIS_BUILD_DIR/vendor/bin:$PATH"

git config --global user.email "timani@getpantheon.com"
git config --global user.name "Pantheon Automation"

# Build the makefile into a separate dir so it is a distinct git working copy.
cd $TRAVIS_BUILD_DIR
git clone --depth 2 ssh://codeserver.dev.$PUUID@codeserver.dev.$PUUID.drush.in:2222/~/repository.git $HOME/.build/repo
drush make example.make $HOME/.build/$PNAME

# Git history switcharoo to generate a specific dif-set.
mv $HOME/.build/repo/.git $HOME/.build/$PNAME/.git
cd $HOME/.build/$PNAME

# Output of the diff vs upstream.
echo "Here's the status change!"
git status

# Make sure we are in git mode
drush psite-cmode $PUUID $PENV git

# Nice commite messages

# Push it real good.
git add --all
git commit -a -m "Makefile build by CI: '$TRAVIS_COMMIT_MSG'"
git push pantheon wp-meetup