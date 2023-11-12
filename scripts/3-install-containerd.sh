# Install containerd
sudo apt-get update && sudo apt-get install -y containerd

# Create containerd config and generate default configuration file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# containerd cri plugin config guide: https://github.com/containerd/cri/blob/release/1.4/docs/config.md
# containerd: https://github.com/containerd/containerd/blob/main/docs/ops.md

# set cgroup driver for containerd to systemd, required for kubelet
        #  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        #     BinaryName = ""
        #     CriuImagePath = ""
        #     CriuPath = ""
        #     CriuWorkPath = ""
        #     IoGid = 0
        #     IoUid = 0
        #     NoNewKeyring = false
        #     NoPivotRoot = false
        #     Root = ""
        #     ShimCgroup = ""
        #     SystemdCgroup = false > SystemdCgroup = true 


# Restart containerd
sudo systemctl restart containerd

# Tell containerd to start services automatically at boot
sudo systemctl enable containerd.service