#!/bin/bash

echo "# JDK"


echo "# Create kafka user, group and home dir"
sudo adduser kafka -d /var/lib/kafka -U -s /usr/sbin/nologin && sudo chmod 0755 /var/lib/kafka



echo "# Get kafka"
sudo curl -L 'https://archive.apache.org/dist/kafka/2.7.0/kafka_2.13-2.7.0.tgz' -o kafka-2.7.0.tgz && sudo tar xzvf kafka-2.7.0.tgz --strip 1 -C /var/lib/kafka



echo "# Zookeeper"

sudo mkdir /etc/zookeeper && sudo chown kafka:kafka /etc/zookeeper && sudo chmod 0755 /etc/zookeeper
sudo mkdir /var/lib/zookeeper && sudo chown kafka:kafka /var/lib/zookeeper && sudo chmod 0755 /var/lib/zookeeper
sudo touch /etc/zookeeper/zoo.cfg && sudo chown kafka:kafka /etc/zookeeper/zoo.cfg && sudo chmod 0644 /etc/zookeeper/zoo.cfg
sudo echo "1" > /etc/zookeeper/myid && sudo chown kafka:kafka /etc/zookeeper/myid && sudo chmod 0644 /etc/zookeeper/myid
sudo ln -s /etc/zookeeper/myid /var/lib/zookeeper/myid
sudo chown root:root /etc/systemd/system/zookeeper.service && sudo chmod 0644 /etc/systemd/system/zookeeper.service
sudo systemctl enable zookeeper.service


echo "# Kafka"

sudo mkdir -P /var/lib/kafka/data/kafka_tmp_folder && sudo chown kafka:kafka /var/lib/kafka/data/kafka_tmp_folder && sudo chmod 0755 /var/lib/kafka/data/kafka_tmp_folder
sudo chown kafka:kafka /var/lib/kafka/config/server.properties && sudo chown 0644 /var/lib/kafka/config/server.properties
sudo chown root:root /etc/systemd/system/kafka.service && sudo chmod 0644 /etc/systemd/system/kafka.service
sudo systemctl enable kafka.service


echo "# Jolokia"

sudo mkdir /opt/jolokia && sudo chown root:root /opt/jolokia && sudo chmod 0644 /opt/jolokia
sudo curl -L https://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar -o /opt/jolokia


echo "# Jolokia-Telegraf"
sudo chown telegraf:telegraf /etc/telegraf/telegraf.d/input-jolokia.conf && sudo chmod 0644 /etc/telegraf/telegraf.d/input-jolokia.conf



echo "# Filebeat"
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
sudo yum install filebeat
sudo systemctl enable filebeat 
