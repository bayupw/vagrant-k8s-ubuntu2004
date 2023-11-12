# kubeadm init vars
export KUBERNETES_VERSION="1.27.3"
export CONTROL_NODE_IP="192.168.56.100"
export POD_NETWORK_CIDR="10.244.0.0/16"
# export LB="192.168.56.100"

sudo systemctl enable kubelet

# initialise cluster
sudo kubeadm init \
  --apiserver-advertise-address=$CONTROL_NODE_IP \
  --pod-network-cidr=$POD_NETWORK_CIDR \
  --ignore-preflight-errors=all \
  --skip-phases=addon/kube-proxy \
  --kubernetes-version $KUBERNETES_VERSION
#  --control-plane-endpoint=$LB \

# sudo mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$MASTER_NODE_IP\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf