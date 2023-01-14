Vagrant.configure("2") do | config |
    config.vm.define "service" do |service|
        service.vm.box = "Ubuntu-Vagrant"
        service.vm.hostname = "service"
	service.vm.network "private_network", ip: "192.168.100.100"
		service.vm.network "forwarded_port", guest: 80, host:8000
	service.vm.network "forwarded_port", guest: 8080, host:8080
        	service.vm.provision "shell", path: "provision.sh"    
	service.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--memory", "2048"]
        	end
		config.vm.provision "file", source: "./serviceone/", destination: "$HOME/service/serviceone"
		config.vm.provision "file", source: "./servicetwo/", destination: "$HOME/service/servicetwo"
    end    
end
