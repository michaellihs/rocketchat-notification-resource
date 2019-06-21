#!/usr/bin/env bash

export ROOT_URL='chat.dev.localhost'
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo mkdir -p ${CURR_DIR}/runtime/db
sudo mkdir -p ${CURR_DIR}/dump

docker-compose up -d

until curl -f -s --noproxy ${ROOT_URL} "http://${ROOT_URL}:3000" > /dev/null
do
    echo 'Waiting for RocketChat to be up and running... (waiting 10sec)'
    sleep 10
done

open "http://${ROOT_URL}:3000"