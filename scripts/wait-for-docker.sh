#!/bin/bash
# Simple script to check and wait for docker engine to be installed and start

function log {
  echo "[$(date --rfc-3339=seconds)]: $*"
}

fail_count=0

while true; do
  docker_info=$(docker info >/dev/null 2>&1)
  if [[ $? -ne 0 ]]; then
    if [ $fail_count -eq 11 ]; then
      log "Docker unavailable"
      exit 2
    else
      fail_count=$[$fail_count+1]
      log "Attempt ${fail_count}/10: Docker not yet availble"
      sleep 3
    fi
  else
    log "Docker available"
    log "Waiting 30s for Droplet to finalize..."
    sleep 30
    exit 0
  fi
done
