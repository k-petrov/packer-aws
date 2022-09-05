#!/bin/bash

echo "# Adding trader_7 repo"
cat <<EOF | sudo tee /etc/yum.repos.d/trader_7.repo
[trader_7]
name=Trader Repository - CentOS 7
baseurl=http://10.64.95.30/trader_7
enabled=True
gpgcheck=False
priority=1
EOF

echo "# JDK"
sudo wget http://10.64.95.30/trader_7/jdk11-11.0.2-00.x86_64.rpm -P /root
sudo rpm -i /root/jdk11-11.0.2-00.x86_64.rpm

echo "# Kafka"
sudo adduser kafka -d /var/lib/kafka -U -s /usr/sbin/nologin && sudo chmod 0755 /var/lib/kafka
sudo mkdir -p /var/lib/kafka/data/kafka_tmp_folder && sudo chown kafka:kafka /var/lib/kafka/data/kafka_tmp_folder && sudo chmod 0755 /var/lib/kafka/data/kafka_tmp_folder
sudo curl -L 'https://archive.apache.org/dist/kafka/2.7.0/kafka_2.13-2.7.0.tgz' -o /root/kafka-2.7.0.tgz && sudo tar xzvf /root/kafka-2.7.0.tgz --strip 1 -C /var/lib/kafka

echo "# Jolokia"
sudo mkdir /opt/jolokia && sudo chmod 0644 /opt/jolokia
sudo curl -L 'https://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar' -o /root/jolokia-jvm-1.6.2-agent.jar && sudo mv /root/jolokia-jvm-1.6.2-agent.jar /opt/jolokia/


echo "# Filebeat"
cat <<EOF | sudo tee /etc/yum.repos.d/elastic.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
sudo yum install filebeat -y
