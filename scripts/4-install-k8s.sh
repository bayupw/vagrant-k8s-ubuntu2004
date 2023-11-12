# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Add apt repository gpg key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes apt repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package list
sudo apt-get update

# List kubelet versions
# apt-cache policy kubelet | head -n 20

# kubelet:
#   Installed: (none)
#   Candidate: 1.28.2-00
#   Version table:
#      1.28.2-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.28.1-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.28.0-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.27.6-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.27.5-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.27.4-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.27.3-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#      1.27.2-00 500
#         500 https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages

# Install kubelet, kubadm, kubectl
sudo apt-get install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION kubernetes-cni

sudo apt-mark hold kubelet kubeadm kubectl

# Tell kubelet to start services automatically at boot
sudo systemctl enable kubelet.service