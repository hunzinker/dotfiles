#!/bin/bash

function wan_ip_address() {
  ip=$(curl -s ifconfig.co)
  echo -n "${ip} "
}

function lan_ip_address() {
  # Loop through the interfaces and check for the interface that is up.
  for file in /sys/class/net/*; do

    iface=$(basename $file);

    read status < $file/operstate;

    [ "$status" == "up" ] && ip addr show $iface | awk '/inet /{printf $2" "}'

  done
}

function cpu_temperature() {
  # Display the temperature of CPU core 0 and core 1.
  sensors | awk '/Core 0/{printf $3" "}/Core 1/{printf $3" "}'
}

function memory_usage() {
  if [ "$(which bc)" ]; then
    read total used <<< $(free | awk '/Mem/{printf $2" "$3}')
    percent=$(bc -l <<< "100 * ($total / $used)")
    awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "%sMi/%sMi %.1f% ", t, u, p}'
  fi
}

function load_average() {
  printf "%s " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"
}

function date_time() {
  printf "%s" "$(date +'%Y-%m-%d %H:%M:%S %Z')"
}

function main() {
  # wan_ip_address
  # lan_ip_address
  # cpu_temperature
  # memory_usage
  load_average
  date_time
}

main
