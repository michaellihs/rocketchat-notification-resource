#!/usr/bin/env bash

concourse_fqdn='concourse.dev.localhost'

curl --noproxy ${concourse_fqdn} -s -f -o fly "http://${concourse_fqdn}:8080/api/v1/cli?arch=amd64&platform=darwin"
chmod u+x fly

./fly --target=rocket-notify login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main

./fly --target=rocket-notify set-pipeline \
    --non-interactive \
    --pipeline=rocket-notify-dev \
    --config=pipeline.yml

./fly --target=rocket-notify unpause-pipeline -p rocket-notify-dev