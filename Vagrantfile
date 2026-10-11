# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu 24.04 LTS
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.hostname = "bd-lab-node1"

  # Private network
  config.vm.network "private_network", ip: "192.168.56.2"

  # JupyterLab
  config.vm.network "forwarded_port",
    guest: 8888, host: 8897,
    host_ip: "0.0.0.0",
    auto_correct: false

  # Optional services / Spark interfaces
  config.vm.network "forwarded_port",
    guest: 8787,  host: 8787,
    host_ip: "0.0.0.0"

  config.vm.network "forwarded_port",
    guest: 8080,  host: 8081,
    host_ip: "0.0.0.0"

  config.vm.network "forwarded_port",
    guest: 7070,  host: 7070,
    host_ip: "0.0.0.0"

  # Spark application UI
  config.vm.network "forwarded_port",
    guest: 4040, host: 4040,
    host_ip: "0.0.0.0",
    auto_correct: true

  # Spark History Server
  config.vm.network "forwarded_port",
    guest: 18080, host: 18080,
    host_ip: "0.0.0.0",
    auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Spark-Lab-2026"
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.provision "shell", path: "provisioning.sh"

end