# TOSCA in a nutshell

This repository aims to bring the conceptual designs of TOSCA to the real world.
In more detail, you'll find here a TOSCA definition to deploy a VM in OpenStack.

THIS IS STILL UNDER HEAVY DEVELOPMENT!

## yorc + alien4cloud

This was the most promising realization of the TOSCA concept.
And given the endresult, this was kind of worth the hustle with setting it up.

### Folder structure explained

| Folder/File | Explanation                                           |
|-------------|-------------------------------------------------------|
| a4c_stuff   | Self-written TOSCA resources used for PoCs            |
| ansible     | Legacy. NOT used any more, still here to track it     |
| terraform   | resources to deploy a yorc controller VM in OpenStack |
| yorcconf    | how bootstrap files should look like                  |
| s.sh        | connect to your yorc controller deployed by terraform |


### How to yorc

You need a Linux VM. Do not try Windows or mac.

***Bootstrapping***

In order to get yorc working, you need to start yorc.
It will create a yorc server and a consul server holding your data.
It will also create a second VM in the given location to perform tasks for you.
I don't know why this is required but it seems to be importent. You cannot prevent this behavior.

```bash
yorc bootstrap --values my_yaml.yaml
```

In order to receive such a values file, you may want to use the wizzard:
```bash
yorc bootstrap --review
```
The review flag offers you to edit the final yaml file after finishing the wizzard.
If you are in VIM you can then use ":save tmp.yaml" to save this file. Very helpful.
The file contains also two sections *locations* and *location*. There you need to pass
your credentials. The keys for this config are the same used by the respective terraform
providers (e.g. openstacks "username" is *user_name*).

***Show deployments***

Shows all deployments which are managed by the current VM.

```bash
yorc deployments list
```

***Show deployment logs***

This shows log files of deployments and bootstraps.
You'll find a mix of Terraform, Ansible and Yorc logs here.

```bash
yorc deployments logs -b bootstrap-2021-07-16--09-53-49
```

***Cleanup deployments***

With this you can remove deployments via CLI if you are not using Alien4Cloud.
(More on Alien4Cloud later)

```bash
yorc deployments undeploy bootstrap-2021-07-16--09-53-49
yorc deployments purge bootstrap-2021-07-16--09-53-49
```

***Start over***

Trow away all configuration and stop yorc and consul servers:
(Does not remove old deployments, only bootstrapped VMs!)

```bash
yorc bootstrap cleanup
```

***Troubleshooting***

When working with OpenStack based clouds, the controller does not seem to pass the credentials correctly to the bootstrapped instance.
See this issue for more details: https://github.com/ystia/yorc/issues/768
Same goes for AWS: https://github.com/ystia/yorc/issues/769


In short: Login to the bootstrapped yorc instance and do a `sudo yorc locations list`. You will mostlikely see divergent paramters from
your original configuration. To fix this, use `sudo yorc locations update -d '<json-string>'` where the JSON string should look like this:
```json
{ "name": "betacloud", "type": "openstack", "properties": { "auth_url": "https://api-1.betacloud.de:5000", "default_security_groups": [ "yorc-all" ], "password": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=password\" | print }}", "private_network_name": "net-to-external-yorc", "project_id": "foobar", "project_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=tenant_name\" | print }}", "provisioning_over_fip_allowed": "true", "tenant_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=tenant_name\" | print }}", "use_vault": "true", "user_domain_name": "betacloud", "user_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=user_name\" | print }}" } }
```
or in a more readable view:
```json
{ "name": "betacloud",
  "type": "openstack",
  "properties": {
    "auth_url": "https://api-1.betacloud.de:5000",
    "default_security_groups": [
      "yorc-all"
    ],
    "password": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=password\" | print }}",
    "private_network_name": "net-to-external-yorc",
    "project_id": "foobar",
    "project_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=tenant_name\" | print }}",
    "provisioning_over_fip_allowed": "true",
    "tenant_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=tenant_name\" | print }}",
    "use_vault": "true",
    "user_domain_name": "betacloud",
    "user_name": "{{ secret \"/secret/yorc/locations/betacloud\" \"data=user_name\" | print }}"
  }
}
```
Note that the JSON string needs to be encapsulated in single quotes and double quotes in values must be escaped with a backslash.

For AWS:
```json
{ "name": "awseucentral1", "type": "aws", "properties": { "access_key": "{{ secret \"/secret/yorc/locations/awseucentral1\" \"data=access_key\" | print }}", "region": "eu-central-1", "secret_key": "{{ secret \"/secret/yorc/locations/awseucentral1\" \"data=secret_key\" | print }}" } }
```
Or in readable:
```json
{ "name": "awseucentral1",
  "type": "aws",
  "properties": {
    "access_key": "{{ secret \"/secret/yorc/locations/awseucentral1\" \"data=access_key\" | print }}",
    "region": "eu-central-1",
    "secret_key": "{{ secret \"/secret/yorc/locations/awseucentral1\" \"data=secret_key\" | print }}"
  }
}
```

### Alien4Cloud (A4C)

***Get started***

Again, we are focusing on OpenStack. Whith yorc set up, login to your A4C webpage with "admin" "admin".
Head over to Administration > Orchestrators > Yorc > Locations. Here you'll find *On demand ressources*.
These are some kind of template. A4C will later try to map your designed infrastructure to these components.
Unfortunately the preset templates are way to restrictive (for me it was only the compute one).
I resolved this by creating a new compute resource and removed nearly every preset except for these:
  - **protocol** TCP
  - **network_name** PRIVATE
  - **initiator** source
  - **min_instances** 1
  - **max_instances** 1
  - **default_instances** 1

In the next step you might want to add some predefined stuff you can reuse later.
Head over to Catalog > Manage archives > Git import (the blue button). From there you can add several git
repositories. I used the following examples:

**a4c samples**
  - Repository URL: https://github.com/alien4cloud/samples.git
  - Credentials: None
  - On Branch or Tag: 3.0.x
  - Archives to import: *

**a4c csar public library**
  - Repository URL: https://github.com/alien4cloud/csar-public-library.git
  - Credentials: None
  - On Branch or Tag: v3.0.x
  - Archives to import: (a bunch, you need to create seperate entries)
    ```
    org/alien4cloud/consul
    org/alien4cloud/java
    org/alien4cloud/elasticsearch
    org/alien4cloud/cloudify/manager/pub
    org/alien4cloud/cloudify/hostpool/pub
    org/alien4cloud/alien4cloud/pub
    org/alien4cloud/alien4cloud/config
    ```

**ystia forge**
  - Repository URL: https://github.com/ystia/forge.git
  - Credentials: None
  - On Branch or Tag: develop
  - Archives to import: org/ystia

Please note: Nearly all examples have aged a bit and there might be situations the examples are not useable any more.
E.g. the docker software component installation requires now apt-transport-https on debian based systems. This is not installed
currently, a pull request is open though.

As we required a simple PoC we decided to create our own docker installation and container based on the above examples:

**tosca in a nutshell**
  - Repository URL: https://github.com/osism/tosca-in-a-nutshell.git
  - Credentials: None
  - On Branch or Tag: main
  - Archives to import: 
    ```
    a4c_stuff/docker
    a4c_stuff/heimdallvm (contains an example topology for a heimdall docker container on a vm)
    ```

***How to create an application***

This is the way to create our PoC.
Create a new application and head over to the topology designer.
Select a *Compute* node (OpenStack, AWS). Drag our docker resource onto the compute resource.
You can easily identify our PoC resources by the icons which only contain text. And yet again drag
the *heimdall* resource onto the docker resource. You need to specify some settings for the compute resource.
After that, you should be ready to deploy.
Switch back to your application view and go to your deployments, and follow the wizzard-like guide (select your location, etc.). After that you should see a deploy button, which you might use now.
After some time your application should become available. Congratulations! 

## IM

Another realization of the TOSCA concept is done via GRyCAP's Infrastructure Manager (IM).
This was way trickier as you need to provide your TOSCA file completely handwritten with imports based on githubusercontent raw files.
We have not managed to get this working (yet!).
