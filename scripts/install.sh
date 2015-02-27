#!/bin/bash

# Dynamic hosts through Pantheon mean constantly checking interactively
# that we mean to connect to an unknown host. We ignore those here.
echo "StrictHostKeyChecking no" > ~/.ssh/config 

# Use that as our path
export PATH="$TRAVIS_BUILD_DIR/vendor/bin:$PATH"

git config --global user.email "timani27@gmail.com"
git config --global user.name "Pantheon Automation"

# Build the makefile into a separate dir so it is a distinct git working copy.
cd $TRAVIS_BUILD_DIR
git clone --depth 2 ssh://codeserver.dev.$PUUID@codeserver.dev.$PUUID.drush.in:2222/~/repository.git $HOME/.build/repo

# Git history switcharoo to generate a specific dif-set.
mkdir $HOME/.build/$PNAME
mv $HOME/.build/repo/.git $HOME/.build/$PNAME/.git
cd $HOME/.build/$PNAME

# Output of the diff vs upstream.
echo "-----------------------------------"
echo "Here's the status change!"
echo "-----------------------------------" 
# git status
 
# Push it real good.
git branch -v
git remote -v
git add --all
git commit -a -m "Makefile build by CI: '$COMMIT_MSG'"
# git push pantheon wp-meetup
