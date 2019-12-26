Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/bionic64"

  config.vm.box_download_insecure = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "master" do |control|
   	control.vm.hostname = "master.vm"
    control.vm.network "private_network", ip: "192.168.50.10"
    control.vm.provision :shell, privileged:false, path: 'scripts/master.sh'
  end

  (1..2).each do |i|
    config.vm.define "k8s-node#{i}" do |node|
      node.vm.hostname = "k8s-node#{i}.vm"
      node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
      node.vm.provision :shell, inline: 'cat /vagrant/control.pub >> /home/vagrant/.ssh/authorized_keys'
    end
  end

end
