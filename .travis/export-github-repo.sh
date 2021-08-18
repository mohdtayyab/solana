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
git remote set-url origin https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name"
echo "origin"
#git fetch origin master:tmp
#git rebase tmp
# git fetch origin master
# git config pull.rebase false  
# git config pull.rebase true   
# git config pull.ff only  
# git pull origin master
git config --global user.email "mohdtayyabali1998@gmail.com"
git config --global user.name "Tayyab"
git pull origin master --allow-unrelated-histories 
#git merge origin origin/master
git submodule add https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name" .github_export/solana-web3.js
# git rm --cached .github_export/"$repo_name"
git -C .github_export/"$repo_name" push https://"$GITHUB_TOKEN"@github.com/mohdtayyab/"$repo_name"
