#!/usr/bin/env sh

vm=$1

usage() {
cat <<-USAGE

    usage: create_vm.sh [vm name]

USAGE
}

if [[ -z $vm ]]; then
    usage
    exit 1
fi

docker-machine create --driver virtualbox $vm

if [ $? -ne 0 ]; then
    echo "Docker Machines:"
    docker-machine ls
    exit 1
fi
