#!/usr/bin/env bash
#
# Exports a subdirectory into another github repository
#

set -e
if [[ -z $GITHUB_TOKEN ]]; then
  echo GITHUB_TOKEN not defined
  exit 1
fi

cd "$(dirname "$0")/.."

pip3 install git-filter-repo

declare subdir=$1
declare repo_name=$2

[[ -n "$subdir" ]] || {
  echo "Error: subdir not specified"
  exit 1
}
[[ -n "$repo_name" ]] || {
  echo "Error: repo_name not specified"
  exit 1
}

echo "Exporting $subdir"

set -x
rm -rf .github_export/"$repo_name"
git clone https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name" .github_export/"$repo_name"
git filter-repo --subdirectory-filter "$subdir" --target .github_export/"$repo_name"

git config --global user.email "mohdtayyabali1998@gmail.com"
git config --global user.name "Tayyab"
git fetch 
#git remote set-url origin https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name"
git pull origin master
git merge
git checkout master
git remote -v
#git submodule add https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name" .github_export/solana-web3.js
# git pull https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name"
#git pull https://github.com/mohdtayyab/solana-web3.js.git --no-ff --allow-unrelated-histories
#git pull https://github.com/mohdtayyab/solana-web3.js.git --ff-only --allow-unrelated-histories
#git pull https://github.com/mohdtayyab/solana-web3.js.git
git fetch 





git -C .github_export/"$repo_name" push --force https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name"
