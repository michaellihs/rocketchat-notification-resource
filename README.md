Concourse Resource for RocketChat Notifications
===============================================

This project contains a Concourse Resource for sending notifications to RocketChat.

The repository is based on a fork from [github.com/lucirr/rocketchat-notification-resource](https://github.com/lucirr/rocketchat-notification-resource).


[TOC levels=4]: # "## Contents"

## Contents
- [Resource Configuration](#resource-configuration)
- [Configuration Parameters](#configuration-parameters)
    - [Within the `resources` Section](#within-the-resources-section)
    - [Within the `jobs.plan.on_success|on_failure` section](#within-the-jobsplanon_successon_failure-section)
- [Developer's Guide](#developers-guide)
    - [Spinning up a local Development Environment with `docker-compose`](#spinning-up-a-local-development-environment-with-docker-compose)
        - [Generating Keys for Concourse](#generating-keys-for-concourse)
    - [Running the Tests](#running-the-tests)
    - [Building and pushing the Docker Image for the Resource](#building-and-pushing-the-docker-image-for-the-resource)
    - [Troubleshooting & Debugging](#troubleshooting--debugging)
- [Resources](#resources)


Resource Configuration
----------------------

Here is a sample usage of the RocketChat notification resource

```yaml
resource_types:
- name: rocketchat
  type: docker-image
  source:
    repository: michaellihs/rocket-notify-resource
    tag: dev-1

resources:
- name: rocketchat
  type: rocketchat
  source:
    url: https://rocketchat:3000  
    user: concourse-caas
    password: t0p-s3cr3t

jobs:
  - name: rocketchat-notify
    plan:
      - task: notify
        # ...
        on_success:
          put: rocketchat
          params:
            channel: general
            text: Job 'rocketchat-notify' was successfully triggered
        on_failure:
          put: rocketchat
          params:
            channel: general
            message: Job 'rocketchat-notify' failed
            put: rocketchat
```


## Configuration Parameters

### Within the `resources` Section

| Parameter  | Type   | Required | Default | Description                                                       |
|:-----------|:-------|:---------|:--------|:------------------------------------------------------------------|
| `url`      | URL    | yes      |         | URL of the RocketChat server to send notifications to             |
| `user`     | String | yes      |         | Username with which Concourse authenticates at RocketChat         |
| `password` | String | yes      |         | Password with which Concourse authenticates at RocketChat         |
| `debug`    | String | no       | `false` | If set to `true`, the resource will output only debug information |


### Within the `jobs.plan.on_success|on_failure` section

| Parameter | Type   | Required | Default     | Description                                                        |
|:----------|:-------|:---------|:------------|:-------------------------------------------------------------------|
| `channel` | String | yes      |             | The RocketChat channel where Concourse sends its notifications to  |
| `message` | String | yes      |             | The message send to RocketChat                                     |
| `alias`   | String | no       | `Concourse` | The use alias with which Concourse sends the message to RocketChat |


Developer's Guide
-----------------

This section provides some information for those who want to join development on this resource.


### Spinning up a local Development Environment with `docker-compose`


1. Make sure to have Docker and Docker Compose installed on your workstation
2. Create a host entry in your `/etc/hosts` file

    ```
    127.0.0.1       chat.dev.localhost concourse.dev.localhost
    ```

3. `cd` into the `dev/rocket-chat` directory and use the provided shell script to spin up RocketChat

    ```
    cd dev/rocket-chat
    ./rocketchat-up.sh
    ```

4. After a while the RocketChat URL should open up in your browser. You can login with user `admin` password `admin`
5. Provide some organization information and you are good to go.
6. `cd` into the `dev/concourse` directory and use the provided shell script to spin up Concourse

    ```
    cd dev/concourse
    ./concourse-up.sh
    ```

7. After a while, Concourse should open up in your browser. You can login to Concourse with user `test` and password `test`


> **Warning**: For convenience, this repository comes with a set of default keys used by Concourse. Make sure to re-create those keys if you want to run Concourse in a more production setup.


#### Generating Keys for Concourse

Follow steps in https://concourse-ci.org/concourse-generate-key.html

```
root@f39bb0c9da87:/usr/local/concourse/bin# cd /concourse-keys/
root@f39bb0c9da87:/concourse-keys# /usr/local/concourse/bin/concourse generate-key -t ssh -f ./worker_key
wrote private key to ./worker_key
wrote ssh public key to ./worker_key.pub
root@f39bb0c9da87:/concourse-keys# cd /concourse-keys && /usr/local/concourse/bin/concourse generate-key -t ssh -f ./worker_key
wrote private key to ./worker_key
wrote ssh public key to ./worker_key.pub
root@f39bb0c9da87:/concourse-keys# cd /concourse-keys && /usr/local/concourse/bin/concourse generate-key -t ssh -f ./tsa_host_key
wrote private key to ./tsa_host_key
wrote ssh public key to ./tsa_host_key.pub
root@f39bb0c9da87:/concourse-keys# cd /concourse-keys && /usr/local/concourse/bin/concourse generate-key -t ssh -f ./session_signing_key
wrote private key to ./session_signing_key
wrote ssh public key to ./session_signing_key.pub
root@f39bb0c9da87:/concourse-keys# cp worker_key.pub authorized_worker_keys
```


### Running the Tests

The resource ships with a bunch of integration tests, in order to run them:

```bash
cd test
./all.sh
```

The tests are also part of the `Dockerfile` and will run with every build of the image. Build will fail if tests fail.


### Building and pushing the Docker Image for the Resource

```bash
./build.sh VERSION REPOSITORY
```


### Troubleshooting & Debugging

* hijacking the resource container in the dev pipeline

    ```bash
    cd dev
    ./fly -t rocket-notify hijack -j rocket-notify-dev/rocketchat-notify -c rocket-notify-dev/rocketchat
    ```


Resources
---------

* [Concourse Documentation on Developing Custom Resource Types](https://concourse-ci.org/implementing-resource-types.html)
* [Developing a custom Concourse Resource](https://content.pivotal.io/blog/developing-a-custom-concourse-resource)
* [Slack Resource for Concourse](https://github.com/cloudfoundry-community/slack-notification-resource)
* [RocketChat and Docker Compose](https://rocket.chat/docs/installation/docker-containers/index.html)
* [RocketChat REST API](https://rocket.chat/docs/developer-guides/rest-api/)
