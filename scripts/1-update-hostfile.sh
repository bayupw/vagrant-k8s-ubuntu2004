echo "$CONTROLNODE_IPADDRESS $CONTROLNODE_HOSTNAME" | sudo tee -a /etc/hosts
echo "$WORKERNODE1_IPADDRESS $WORKERNODE1_HOSTNAME" | sudo tee -a /etc/hosts
echo "$WORKERNODE2_IPADDRESS $WORKERNODE2_HOSTNAME" | sudo tee -a /etc/hosts

# Update DNS server
sudo sed -i -e "s/#DNS=/DNS=$DNSSERVER/" /etc/systemd/resolved.conf
sudo service systemd-resolved restart