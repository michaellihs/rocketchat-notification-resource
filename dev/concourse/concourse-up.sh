#!/usr/bin/env bash

export CONCOURSE_FQDN='concourse.dev.localhost'
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker-compose up -d

until curl -f -s --noproxy ${CONCOURSE_FQDN} "http://${CONCOURSE_FQDN}:8080" > /dev/null
do
    echo 'Waiting for Concourse to be up and running... (waiting 2sec)'
    sleep 2
done

open "http://${CONCOURSE_FQDN}:8080"