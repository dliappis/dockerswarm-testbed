require "ipaddr"

boxname = "elastic/ubuntu-16.04-x86_64"
base_ip = "192.168.124.100"
domain_name = "swarm.com"

nodes = [
  {hostname: 'm01',
   domain: domain_name,
   box: boxname,
   memory: 2048,
   autostart: true},
  {hostname: 'w01',
   domain: domain_name,
   box: boxname,
   memory: 2048,
   autostart: true},
  {hostname: 'w02',
   domain: domain_name,
   box: boxname,
   memory: 2048,
   autostart: true},
]

VAGRANT_VM_PROVIDER = ENV["VAGRANT_DEFAULT_PROVIDER"] || "virtualbox"
ANSIBLE_RAW_SSH_ARGS = []

Vagrant.configure("2") do |config|
  ip_address = IPAddr.new base_ip


  # https://github.com/mitchellh/vagrant/pull/5765#issuecomment-120247738
  nodes.each do |node|
    ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/#{node[:hostname]}/#{VAGRANT_VM_PROVIDER}/private_key"
  end

  nodes.each do |node|
    fqdn = node[:hostname] + '.' + node[:domain]
    config.vm.define node[:hostname], autostart: (node[:autostart] || false) do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = fqdn

      #node_config.ssh.forward_agent = true
      node_config.vm.network :private_network, ip: ip_address.to_s

      node_config.vm.provider :virtualbox do |virtualbox, override|
        virtualbox.name = fqdn
        virtualbox.memory = node[:memory] || 2048
        virtualbox.cpus = 2
        override.vm.synced_folder './','/vagrant'
      end

      node_config.vm.provider :libvirt do |libvirt, override|
        libvirt.cpus = 2
        libvirt.memory = node[:memory] || 2048
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
