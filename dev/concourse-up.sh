#!/usr/bin/env bash

export ROCKETCHAT_URL='chat.dev.localhost'
export CONCOURSE_FQDN='concourse.dev.localhost'
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${CURR_DIR}/runtime/db
mkdir -p ${CURR_DIR}/dump
mkdir -p ${CURR_DIR}/data
mkdir -p ${CURR_DIR}/uploads

docker network inspect rocket-notify &>/dev/null ||
    docker network create --driver bridge rocket-notify

docker-compose up -d

until curl -f -s --noproxy ${ROCKETCHAT_URL} "http://${ROCKETCHAT_URL}:3000" > /dev/null
do
    echo 'Waiting 10 sec for RocketChat to be up and running...'
    sleep 10
done

open "http://${ROCKETCHAT_URL}:3000"

until curl -f -s --noproxy ${CONCOURSE_FQDN} "http://${CONCOURSE_FQDN}:8080" > /dev/null
do
    echo 'Waiting 2 sec for Concourse to be up and running...'
    sleep 2
done

open "http://${CONCOURSE_FQDN}:8080"