Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.define "ubuntu"
    config.vm.hostname = ubuntu
    config.dns.tld = 'k8s'

    config.vm.network "private_network", ip: '172.16.2.10'

    config.vm.provider :virtualbox do |vb|
        vb.name = ubuntu
        vb.memory = 768
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
end