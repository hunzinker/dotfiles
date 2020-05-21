#!/usr/bin/env bash

set -e

region="us-east-1"
max_shards=0
iterator_type="TRIM_HORIZON"

usage() {
cat <<-USAGE

    usage: get_records.bash [OPTIONS]

    depends on gimme-aws-creds

    -n kinesis stream name              Ex: feed-uuid.
    -s shards                           Number of shards >=0. Default 0.
    -t iterator type                    Default TRIM_HORIZON.
    -r aws region                       AWS region. Default 'us-east-1'.
    -v verbose                          set -x

    (-h)                                Display this message.

    Example: get_records.bash -n feed-1234 -s 0 -r us-west-2

    Example output: [file byte size] feed-1234-shard0

    Additional args pass through to `aws kinesis get-shard-iterator`.

    Example: get_records.bash -n feed-1234 -s 0 -t AT_SEQUENCE_NUMBER -r us-west-2 -- --starting-sequence-number abcde

USAGE
}

while getopts ":n:s:t:r:vh" opt; do
    case ${opt} in
        n)
            stream_name=$OPTARG
            ;;
        s)
            if [[ $OPTARG -le 0 ]]; then
                max_shards=0
            else
                max_shards=$(($OPTARG - 1))
            fi
            ;;
        t)
            iterator_type=$OPTARG
            ;;
        r)
            region=$OPTARG
            ;;
        v)
            set -x
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            printf "Unknown option: %s\n" $OPTARG
            usage
            exit 1
            ;;
        \:)
            printf "Argument missing: %s option\n" $OPTARG
            usage
            exit 1
            ;;
    esac
done
shift $(($OPTIND - 1))

shards=$(seq 0 $max_shards)

get_records() {
    for shard in $shards; do
        shard_iterator=$(aws kinesis get-shard-iterator \
            --stream-name $stream_name \
            --shard-id $shard \
            --shard-iterator-type $iterator_type \
            --region $region \
            $@ | jq -r '.ShardIterator')

        aws kinesis get-records \
            --region $region \
            --shard-iterator $shard_iterator \
            --limit 10000 \
            | jq -r '.Records[].Data' > ${stream_name}-shard${shard}

        wc -c ${stream_name}-shard${shard}
    done
}

if [[ -z $stream_name || -z $region ]]; then
    usage
    exit 1
else
    get_records $@
    exit 0
fi
