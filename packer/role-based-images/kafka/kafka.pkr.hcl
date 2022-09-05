packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "kafka" {
  ami_name = "packer-master-img-kafka-${formatdate("MM-DD-YYYY", timestamp())}"
  source_ami_filter {
    filters = {
       name = "packer-master-img-*"
    }
    owners = ["self"]
    most_recent = true
  }
  instance_type = "t2.micro"
  region        = "eu-central-1"
  security_group_id = "sg-09d9ded17f8af628a"
  ssh_keypair_name = "noc-test"
  ssh_private_key_file = "~/.ssh/noc-test.pem"
  associate_public_ip_address = "false"
  vpc_id = "vpc-0e184ddf70dbf8f32"
  subnet_id = "subnet-098f03ca795cf3b87"
  ssh_username = "ec2-user"
}

build {
  name    = "packer-master-img-kafka"
  sources = [
    "source.amazon-ebs.kafka"
  ]

provisioner "file" {
    source = "install.sh"
    destination = "/tmp/install.sh"
}

provisioner "shell" {
    inline = ["sudo bash /tmp/install.sh", "rm -f /tmp/install.sh"]
}

}
