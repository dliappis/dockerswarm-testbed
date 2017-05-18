.PHONY: default

default: ve
	vagrant plugin list | grep -q vagrant-libvirt && vagrant plugin list | grep -q vagrant-sshfs || vagrant plugin install vagrant-sshfs

ve: requirements.txt
	test -d ve || virtualenv --python=python2.7 ve
	ve/bin/pip install -r requirements.txt
	touch ve
