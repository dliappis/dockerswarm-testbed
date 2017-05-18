## Docker Swarm testbed

This repo has been created as a simple vagrant based testbed to aid familiarizing yourself with the new orchestration features starting with docker 1.12.

For a tutorial of the swarm mode have a look at: https://docs.docker.com/engine/swarm/swarm-tutorial/

### Prerequisites **on the host**

- Vagrant (preferably >=1.8.6)
- Ansible >=2.0
- Virtualbox >=5.0 or
  [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) on kvm + vagrant-sshfs

### Usage

#### Virtualbox

Just do `vagrant up`.
Optionally, if you want to install ansible in a virtualenv: `make && source ve/bin/activate` and then `vagrant up`.

#### Libvirt

```shell
make
source ve/bin/activate # Will install vagrant-sshfs
vagrant up
```

You will end up with 3 vagrant boxes:

| Vagrant Machine Name | Docker Role |
| ----- | ---- |
| m01 | Manager node |
| w01 | Worker node |
| w02 | Worker node |

After `vagrant up` is done, you should be able to `vagrant ssh <machinename>` and issue `docker node ls` to see the swarm nodes.

[docker-swarm-visualizer](https://github.com/DovAmir/docker-swarm-visualizer) runs on m01 and you can access it on [http://192.168.124.100:3000](http://192.168.124.100:3000).

And overlay network named `net001` will get configured too in case your application "stack" includes components that need to talk to each other.
