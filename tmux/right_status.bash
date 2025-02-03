#!/bin/bash

wan_ip_address() {
  ip=$(curl -s ifconfig.co)
  echo -n "${ip} |"
}

load_average() {
  printf "%s | " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"
}

dateime() {
  printf "%s" "$(date +'%Y-%m-%d %H:%M:%S %Z')"
}

main() {
  wan_ip_address
  load_average
  dateime
}

main
