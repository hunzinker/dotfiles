#!/bin/sh
#
# Decrypt encrypted file.

usage() {
cat <<-USAGE

    usage: decrypt.sh [input file] [output file]

USAGE
}

if [[ -z $1 || -z $2 ]]; then
    usage
    exit 1
fi

/usr/bin/env openssl enc -cast5-cfb -d -in $1 -out $2
