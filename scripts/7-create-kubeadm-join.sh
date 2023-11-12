KUBEADM_PATH="/vagrant/kubeadm-join"

if [ -d $KUBEADM_PATH ]; then
  rm -f $KUBEADM_PATH/*
else
  mkdir -p $KUBEADM_PATH
fi

touch $KUBEADM_PATH/kubeadm-join.sh
chmod +x $KUBEADM_PATH/kubeadm-join.sh

kubeadm token create --print-join-command > $KUBEADM_PATH/kubeadm-join.sh