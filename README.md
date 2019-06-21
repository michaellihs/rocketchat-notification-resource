Concourse Resource for RocketChat Notifications
===============================================

This project contains a Concourse Resource for sending notifications to RocketChat.

The repository is a fork from [github.com/lucirr/rocketchat-notification-resource](https://github.com/lucirr/rocketchat-notification-resource).


Resource Configuration
----------------------

(draft)

```yaml
resource_types:
- name: rocketchat
  type: docker-image
  source:
    repository: rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource
    # tag: 0.0.1

resources:
- name: rocketchat
  type: rocketchat
  source:
    url: https://chatops.devtools.int.us1.bosch-iot-cloud.com  
    user: concourse-caas
    password: t0p-s3cr3t
    channel: 'lalaland'
```

Developer's Guide
-----------------

This section provides some information for those who want to join development on this resource.


### Spinning up a local RocketChat with `docker-compose`

This section follows the [official RocketChat documentation for containerized setups](https://rocket.chat/docs/installation/docker-containers/index.html).

1. Make sure to have Docker and Docker Compose installed on your workstation
2. Create a host entry in your `/etc/hosts` file

    ```
    127.0.0.1       chat.dev.localhost
    ```

3. `cd` into the `dev/rocket-chat` directory and use the provided shell script to spin up RocketChat

    ```
    cd dev/rocket-chat
    ./rocketchat-up.sh
    ```

4. After a while the RocketChat URL should open up in your browser. You can login with user `admin` password `admin`
5. Provide some organization information and you are good to go.


### Spinning up a local Concourse with `docker-compose`

1. Make sure you have Docker and Docker Compose installed on your workstation
2. Create a host entry in your ´/etc/hosts´ file

    ```
    127.0.0.1	concourse.dev.localhost
    ```

3. `cd` into the `dev/concourse` directory and use the provided shell script to spin up Concourse

    ```
    cd dev/concourse
    ./concourse-up.sh
    ```

4. You can login to Concourse with user `test` and password `test`


> **Warning**: For convenience, this repository comes with a set of default keys used by Concourse. Make sure to re-create those keys if you want to run Concourse in a more production setup.


#### Generating Keys

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


### Building the image for the resource


On a workstation that does not require a proxy, run

```bash
docker build -t rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource .
docker push rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource
```


Resources
---------

* https://content.pivotal.io/blog/developing-a-custom-concourse-resource

