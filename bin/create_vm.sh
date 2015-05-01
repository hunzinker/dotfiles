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

# Setup bridge ip address
docker-machine ssh $vm sudo "sed -r \"s/EXTRA_ARGS='(.*?)'/EXTRA_ARGS='\1 --bip 10.100.200.1\/24'/\" /var/lib/boot2docker/profile > tmp && sudo mv tmp /var/lib/boot2docker/profile"
docker-machine stop $vm
docker-machine start $vm
