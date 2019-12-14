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
git reset --hard master
git clean -f

git checkout -b "$BASE_BRANCH_NAME$(date +%y%m%d)"

git merge tgstation/master -Xignore-space-change -Xdiff-algorithm=minimal --squash --allow-unrelated-histories

root=$(pwd)
cd $SPACEMERGE_PATH
npm install
npm run build
cd $root

git diff --name-only --diff-filter=U | node "$SPACEMERGE_PATH/process-diffs.js"

node "$SPACEMERGE_PATH/scrub-conflicts.js"

git checkout --theirs .editorconfig
git checkout --theirs tgstation.dme
git checkout --theirs .github/CODEOWNERS
git checkout --ours html/changelogs/.all_changelog.yml
git checkout --ours html/templates/header.html
git checkout --ours README.md
git checkout --ours .travis.yml
git checkout --ours .github/CONTRIBUTING.md
git checkout --ours .github/ISSUE_TEMPLATE/bug_report.md
git checkout --ours .github/ISSUE_TEMPLATE/feature_request.md

echo "And that's all she wrote."
