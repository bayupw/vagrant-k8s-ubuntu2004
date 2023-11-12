# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"
settings = YAML.load_file "settings.yaml"
NUM_WORKER_NODES = settings["nodes"]["worker"]["count"]

Vagrant.configure("2") do |config|
  # Ubuntu 22.04
  # config.vm.box = "ubuntu/jammy64"
    
  # Ubuntu 20.04.6 LTS
  config.vm.box = settings["software"]["box"]
  
  # control node
  config.vm.define "control" do |server|
    server.vm.hostname = settings["nodes"]["control"]["hostname"]

    server.vm.provider "virtualbox" do |vb|
      vb.name = settings["nodes"]["control"]["hostname"]
      vb.cpus = settings["nodes"]["control"]["cpu"]
      vb.memory = settings["nodes"]["control"]["memory"]
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end

    server.vm.network "private_network", ip: settings["nodes"]["control"]["ip"]

    # shell scripts
    server.vm.provision "shell", path: "scripts/0-install-ca-cert.sh"

    # update host file
    server.vm.provision "shell", 
      env: {
        "DNSSERVER" => settings["network"]["dns_server"],
        "CONTROLNODE_HOSTNAME" => settings["nodes"]["control"]["hostname"],
        "CONTROLNODE_IPADDRESS" => settings["nodes"]["control"]["ip"],
        "WORKERNODE1_HOSTNAME" => settings["nodes"]["worker"]["hostname"] + "1",
        "WORKERNODE1_IPADDRESS" => settings["nodes"]["worker"]["ip_prefix"] + "1",
        "WORKERNODE2_HOSTNAME" => settings["nodes"]["worker"]["hostname"] + "2",
        "WORKERNODE2_IPADDRESS" => settings["nodes"]["worker"]["ip_prefix"] + "2",
      },
      path: "scripts/1-update-hostfile.sh"

    server.vm.provision "shell", path: "scripts/2-config-kernel.sh"
    server.vm.provision "shell", path: "scripts/3-install-containerd.sh"
    
    # Install kubelet, kubadm, kubectl
    server.vm.provision "shell",
      env: {
        "KUBE_VERSION" => settings["software"]["kubernetes"],
      },
      path: "scripts/4-install-k8s.sh"

    # kubeadm init
    server.vm.provision "shell",
      env: {
        "KUBERNETES_VERSION" => settings["software"]["kubernetes_version"],
        "CONTROL_NODE_IP" => settings["nodes"]["control"]["ip"],
        "POD_NETWORK_CIDR" => settings["network"]["pod_cidr"],
      },
      path: "scripts/5-initialise-k8s.sh"

    # install calico
    server.vm.provision "shell",
      env: {
        "CALICO_VERSION" => settings["software"]["calico"],
      },
      path: "scripts/6-install-calico.sh"

    # generate kubeadm join script
    server.vm.provision "shell", path: "scripts/7-create-kubeadm-join.sh"

    # cilium
    # server.vm.provision "shell", path: "scripts/5-initialise-k8s-skip-kubelet.sh"
    # server.vm.provision "shell", path: "scripts/6-install-cilium.sh"

  end

  # worker nodes
  (1..NUM_WORKER_NODES).each do |index|
    config.vm.define "worker#{index}" do |server|
      server.vm.hostname = settings["nodes"]["worker"]["hostname"] + "#{index}"  #"worker#{index}"

      server.vm.provider "virtualbox" do |vb|
        vb.name = settings["nodes"]["worker"]["hostname"] + "#{index}"
        vb.cpus = settings["nodes"]["worker"]["cpu"]
        vb.memory = settings["nodes"]["worker"]["memory"]
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
      end

      server.vm.network "private_network", ip: settings["nodes"]["worker"]["ip_prefix"] + "#{index}" #"192.168.56.10#{index}"
      
      # shell scripts
      server.vm.provision "shell", path: "scripts/0-install-ca-cert.sh"
      server.vm.provision "shell", 
        env: {
          "DNSSERVER" => settings["network"]["dns_servers"],
          "CONTROLNODE_HOSTNAME" => settings["nodes"]["control"]["hostname"],
          "CONTROLNODE_IPADDRESS" => settings["nodes"]["control"]["ip"],
          "WORKERNODE1_HOSTNAME" => settings["nodes"]["worker"]["hostname"] + "1",
          "WORKERNODE1_IPADDRESS" => settings["nodes"]["worker"]["ip_prefix"] + "1",
          "WORKERNODE2_HOSTNAME" => settings["nodes"]["worker"]["hostname"] + "2",
          "WORKERNODE2_IPADDRESS" => settings["nodes"]["worker"]["hostname"] + "2",
        },
        path: "scripts/1-update-hostfile.sh"

      server.vm.provision "shell", path: "scripts/2-config-kernel.sh"
      server.vm.provision "shell", path: "scripts/3-install-containerd.sh"

      server.vm.provision "shell",
        env: {
          "KUBE_VERSION" => settings["software"]["kubernetes"],
        },
        path: "scripts/4-install-k8s.sh"

      server.vm.provision "shell", path: "scripts/8-run-kubeadm-join.sh"

    end
  end

end