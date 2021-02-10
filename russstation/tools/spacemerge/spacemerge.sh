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

git branch --track "$BASE_BRANCH_NAME$(date +%y%m%d)" tgstation/master
git checkout -b "$BASE_BRANCH_NAME$(date +%y%m%d)"
rm config/dbconfig.txt
rm config/in_character_filter.txt

git merge tgstation/master -Xignore-space-at-eol -Xdiff-algorithm=minimal --squash --allow-unrelated-histories

root=$(pwd)
cd $SPACEMERGE_PATH
npm install
npm run build
cd $root

git reset -- html/changelogs
git checkout --theirs .gitattributes
git reset -- .github
git reset -- config

git diff --name-only --diff-filter=U | node "$SPACEMERGE_PATH/process-diffs.js"

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
