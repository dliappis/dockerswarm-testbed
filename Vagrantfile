# -*- mode: ruby -*-
# vi: set ft=ruby :

require "ipaddr"

boxname = "elastic/ubuntu-16.04-x86_64"
base_ip = "192.168.124.100"
domain_name = "swarm.com"
default_ram = 2048
default_cpu = 2

workers = 3
masters = 3

nodes = []

# box, cpu will be set to the defaults if not in the hash, you can add them in the hash for node customization
for i in 1..masters
   nodes += [{ hostname: "m%02d" % [i], domain: domain_name, autostart: true }]
end
for i in 1..workers
   nodes += [{ hostname: "w%02d" % [i], domain: domain_name, autostart: true }]
end


VAGRANT_VM_PROVIDER = ENV["VAGRANT_DEFAULT_PROVIDER"] || "virtualbox"
ANSIBLE_RAW_SSH_ARGS = []

Vagrant.configure("2") do |config|
  ip_address = IPAddr.new base_ip


#  # https://github.com/mitchellh/vagrant/pull/5765#issuecomment-120247738
#  nodes.each do |node|
#    ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/#{node[:hostname]}/#{VAGRANT_VM_PROVIDER}/private_key"
#  end

  nodes.each do |node|
    fqdn = node[:hostname] + '.' + node[:domain]
    config.vm.define node[:hostname], autostart: (node[:autostart] || false) do |node_config|
      node_config.vm.box = node[:box] || boxname
      node_config.vm.hostname = fqdn

      #node_config.ssh.forward_agent = true
      node_config.vm.network :private_network, ip: ip_address.to_s

      node_config.vm.provider :virtualbox do |virtualbox, override|
        virtualbox.name = fqdn
        virtualbox.memory = node[:memory] || default_ram
        virtualbox.cpus = node[:cpu] || default_cpu
        override.vm.synced_folder './','/vagrant'
      end

      node_config.vm.provider :libvirt do |libvirt, override|
        libvirt.cpus = node[:cpu] || default_cpu
        libvirt.memory = node[:memory] || default_ram
        override.vm.synced_folder './', '/vagrant', :nfs =>true, :mount_options => ["vers=3"]
      end

      # Move to ip_address+1
      ip_address = ip_address.succ

      if node == nodes.last
        node_config.vm.provision "ansible" do |ansible|
          #ansible.inventory_path = "static_inventory"
          ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
          ansible.limit = "all"
          ansible.playbook = "prep_docker.yml"
        end
      end
    end
  end
end
