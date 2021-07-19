# TOSCA in a nutshell

This repository aims to bring the conceptual designs of TOSCA to the real world.
In more detail, you'll find here a TOSCA definition to deploy a VM in OpenStack.

THIS IS STILL UNDER HEAVY DEVELOPMENT!


### How to yorc

You need a Linux VM. Do not try Windows of mac.

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

### Alien4Cloud (A4C)

Current issues:
- Building topologies check
- deploy them: failes
  Matching > Nodes matching > Compute > No substitution available for this node.
  Whatever this means...
  Akes at GitHub: https://github.com/ystia/yorc/issues/768
