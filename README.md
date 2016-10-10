## Docker Swarm testbed

This repo has been created as a simple vagrant based testbed to aid familiarizing yourself with the new orchestration features starting with docker 1.12.

For a tutorial of the swarm mode have a look at: https://docs.docker.com/engine/swarm/swarm-tutorial/

### Prerequisites **on the host**

- Vagrant (preferably >=1.8.6)
- Ansible >=2.0
- Virtualbox >=5.0

### Usage

Just do `vagrant up`.

You will end up with 3 vagrant boxes:

| Vagrant Machine Name | Docker Role |
| ----- | ---- |
| m01 | Master node |
| w01 | Worker node |
| w02 | Worker node |

After `vagrant up` is done, you should be able to `vagrant ssh <machinename>` and issue `docker node ls` to see the swarm nodes.
