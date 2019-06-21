#!/usr/bin/env bash

export ROOT_URL='chat.dev.localhost'
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo mkdir -p ${CURR_DIR}/runtime/db
sudo mkdir -p ${CURR_DIR}/dump

docker-compose up -d

open http://${ROOT_URL}:3000