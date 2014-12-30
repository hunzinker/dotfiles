#!/bin/sh
#
# Decrypt encrypted file.

usage() {
cat <<-USAGE

    usage: decrypt.sh [input file]

USAGE
}

if [[ -z $1 ]]; then
    usage
    exit 1
fi

/usr/bin/env openssl enc -cast5-cfb -d -in $1
