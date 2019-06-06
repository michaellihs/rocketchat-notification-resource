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
    url: http://rocket-chat.your-company.com  
    user: rocket-chat-user
    password: t0p-s3cr3t
    channel: 'lalaland'
```


Building the image for the resource
-----------------------------------

On a workstation that does not require a proxy, run

```bash
docker build -t rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource .
docker push rb-bic-artifactory.de.bosch.com/caasbic/concourse-rocketchat-notification-resource
```


Resources
---------

* https://content.pivotal.io/blog/developing-a-custom-concourse-resource

