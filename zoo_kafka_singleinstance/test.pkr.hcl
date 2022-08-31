packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "zoo_kafka_singleinstance" {
  ami_name      = "zoo_kafka_singleinstance"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  security_group_id = "sg-00609f32ed4da143e"
  ssh_keypair_name = "kpetrov"
  ssh_private_key_file = "~/.ssh/kpetrov.pem"
  associate_public_ip_address = "true"
  source_ami = "ami-08239eb68bf73282d"
  vpc_id = "vpc-3698fe5c"
  subnet_id = "subnet-07e4d4dbd22ab93b9"
  ssh_username = "ec2-user"
}

build {
  name    = "zoo_kafka_singleinstance"
  sources = [
    "source.amazon-ebs.zoo_kafka_singleinstance"
  ]
provisioner "file" {
    source = "setup.sh"
    destination = "/tmp/setup.sh"
}

provisioner "file" {
    source = "zoo.cfg"
    destination = "/etc/zookeeper/zoo.cfg"
}

provisioner "file" {
    source = "zookeeper_service"
    destination = "/etc/systemd/system/zookeeper.service"
}

provisioner "file" {
    source = "server_properties"
    destination = "/var/lib/kafka/config/server.properties"
}

provisioner "file" {
    source = "kafka_service"
    destination = "/etc/systemd/system/kafka.service"
}

provisioner "file" {
    source = "jolokia_telegraf"
    destination = "/etc/telegraf/telegraf.d/input-jolokia.conf"
}


provisioner "shell" {
    inline = ["sudo bash /tmp/install.sh", "rm /tmp/install.sh"]
}

provisioner "shell" {
    inline = ["sudo bash /tmp/setup.sh"]
}

}
