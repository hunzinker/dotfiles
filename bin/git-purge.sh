#!/bin/sh
#
# Remove sensitive information from a git repo.
t
usage() {
cat <<-USAGE

    usage: git-purge.sh [file]

    For more information:
    git filter-branch --help
USAGE
}

if [[ -z $1 ]]; then
    usage
    exit 1
fi

git filter-branch --index-filter "git rm --cached --ignore-unmatch $1" \
--prune-empty --tag-name-filter cat -- --all
