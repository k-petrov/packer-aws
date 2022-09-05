#!/bin/bash

echo "# Enable EPEL"
sudo amazon-linux-extras install epel -y

echo "# Install ansible"
sudo amazon-linux-extras install ansible2 -y

echo "# Add wazuh gpg key and repo"
sudo rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
sudo cat > /etc/yum.repos.d/wazuh.repo << EOF
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=EL-\$releasever - Wazuh
baseurl=https://packages.wazuh.com/3.x/yum/
protect=1
EOF

echo "# Add telegraf repo"
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF
sudo sed -i "s/\$releasever/$(rpm -E %{rhel})/g" /etc/yum.repos.d/influxdb.repo

echo "# Install packages"
for i in $(cat /tmp/packages_to_install.txt); do sudo yum install $i -y ; done
