#!/bin/bash

readonly BASE_BRANCH_NAME="upstream-merge-"
readonly SPACEMERGE_PATH="russstation/tools/spacemerge"

# Ensure the current directory is a git directory
if [ ! -d .git ]; then
    echo "Error: must run this script from the root of a git repository"
    exit 1
fi

if ! git remote | grep tgstation > /dev/null; then
    git remote add tgstation https://github.com/tgstation/tgstation.git
fi

git fetch --all
git checkout master
git reset --hard origin/master
git clean -f

git checkout -b "$BASE_BRANCH_NAME$(date +%y%m%d)"

git merge tgstation/master -Xignore-space-change -Xdiff-algorithm=minimal --squash --allow-unrelated-histories

git diff --name-only --diff-filter=U | node "$SPACEMERGE_PATH/processDiffs"

git checkout --theirs tgstation.dme
git checkout --ours html/changelogs/.all_changelog.yml
git checkout --ours html/templates/header.html
git checkout --ours README.md
git checkout --ours .travis.yml

echo "And that's all she wrote."
