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


### Building the image for the resource


On a workstation that does not require a proxy, run

```bash
docker build -t rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource .
docker push rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource
```


Resources
---------

* https://content.pivotal.io/blog/developing-a-custom-concourse-resource

