# pull images
sudo kubeadm config images pull

# initialise cluster
sudo kubeadm init \
  --apiserver-advertise-address=$CONTROL_NODE_IP \
  --pod-network-cidr=$POD_NETWORK_CIDR \
  --ignore-preflight-errors=all \
  --kubernetes-version $KUBERNETES_VERSION
#  --control-plane-endpoint=$LB \

# sudo mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$MASTER_NODE_IP\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf