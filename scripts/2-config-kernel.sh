# Install modules for containerd prerequsites
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure modules are loaded after system reboot
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

## Verify packages
# lsmod | grep br_netfilter
# lsmod | grep overlay

# Setup sysctl parameters to forward IPv4, allow iptables to see bridged traffic, persist after reboot
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl paramters without reboot
sudo sysctl --system

## Verify sysctl
# sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward