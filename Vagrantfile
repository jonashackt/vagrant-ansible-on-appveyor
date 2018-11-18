Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.define 'ubuntu'
    config.vm.hostname = 'ubuntu'

    # Vagrant boot needs more time on AppVeyor (see https://help.appveyor.com/discussions/problems/1247-vagrant-not-working-inside-appveyor)
    config.vm.boot_timeout = 1800

    #config.dns.tld = 'k8s'

    #config.vm.network "private_network", ip: '172.16.2.88'

    config.vm.provider :virtualbox do |vb|
        vb.name = 'ubuntu'
        vb.memory = 768
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # Vagrant needs this config on AppVeyor to spin up correctly (see https://help.appveyor.com/discussions/problems/1247-vagrant-not-working-inside-appveyor)
        vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
    end
end