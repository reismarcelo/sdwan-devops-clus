# SD-WAN DevOps

CLUS 23 - Managing Cisco SD-WAN configuration as code using Ansible

This repository is based on the cloud branch of the [CiscoDevNet/sdwan-devops](https://github.com/CiscoDevNet/sdwan-devops) repository, tailored to render Day1 configurations.

In addition to Ansible and Jinja2, these are the main projects/repositories that are being leveraged:
- [CiscoDevNet/python-viptela](https://github.com/CiscoDevNet/python-viptela)
- [CiscoDevNet/sastre-ansible](https://github.com/CiscoDevNet/sastre-ansible)
- [CiscoDevNet/sastre](https://github.com/CiscoDevNet/sastre)

## Installation

## Cloning the repo

```shell
git clone https://github.com/reismarcelo/sdwan-devops-clus.git
```

All operations are run out of the `sdwan-devops-clus` directory:

```bash
cd sdwan-devops-clus
```

## Instructions for DEVWKS-2016

- Connect the VPN using the provided credentials in order to access the lab.

### Main workflow steps
```shell
./play.sh generate-template-all.yml -i inventory/CL_SDWAN_TEMPLATE/ -t feature-banner -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90

./play.sh generate-template-all.yml -i inventory/CL_SDWAN_TEMPLATE/ -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90

./play.sh query-attach.yml -i inventory/CL_SDWAN_ATTACH/ --limit site3-vedge01 -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90

./play.sh attach-template.yml -i inventory/CL_SDWAN_ATTACH/ --limit site3-vedge01 -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90
```

### Optional steps

Reset vManage configuration back to the starting point
```shell
./play.sh sdwan-restore.yml -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90 -t restore:init
```

Create a snapshot of vManage configuration
```shell
./play.sh sdwan-backup.yml -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90
```
Default backup name follow the pattern backup_<vmanage-ip>_<YYYYMMDD>. Can be customized by passing -e vmanage_snapshot=<custom-name>.

Restore vManage configuration from a snapshot
```shell
./play.sh sdwan-restore.yml -e vmanage_password=C1sco12345 -e vmanage_user=admin -e vmanage_host=10.10.20.90 -t restore:snapshot
```
Default snapshot name follow the pattern backup_<vmanage-ip>_<YYYYMMDD>. Can be customized by passing -e vmanage_snapshot=<custom-name>.

### Running with Docker

The play.sh script used to call the playbooks is basically a wrapper to docker run. The container image used contains all required dependencies, simplifying the installation/deployment.

By default, play.sh uses a container image built by the cloud branch of [CiscoDevNet/sdwan-devops](https://github.com/CiscoDevNet/sdwan-devops). Custom images can be built using the Dockerfile in this repository. In order for play.sh to 
pick a custom image, the IMAGE environment variable must be set accordingly.

Creating your own docker image and using it with play.sh:
```bash
docker build -t sdwan-devops-clus .

export IMAGE=sdwan-devops-clus

./play.sh <playbook> <options>
```

Another form of calling play.sh is to pass the -d option (as in debug):
```bash
./play.sh -d
```
I will open an interactive shell in the container, which can be helpful during troubleshooting.

