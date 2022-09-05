packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "test" {
  ami_name      = "packer-master-img-${formatdate("MM-DD-YYYY", timestamp())}"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  security_group_id = "sg-09d9ded17f8af628a"
  ssh_keypair_name = "noc-test"
  ssh_private_key_file = "~/.ssh/noc-test.pem"
  associate_public_ip_address = "false"
  source_ami = "ami-0e2031728ef69a466"
  vpc_id = "vpc-0e184ddf70dbf8f32"
  subnet_id = "subnet-098f03ca795cf3b87"
  ssh_username = "ec2-user"
}

build {
  name    = "packer-master-image"
  sources = [
    "source.amazon-ebs.test"
  ]

provisioner "file" {
    source = "packages_to_remove.txt"
    destination = "/tmp/packages_to_remove.txt"
}

provisioner "file" {
    source = "packages_to_install.txt"
    destination = "/tmp/packages_to_install.txt"
}

provisioner "file" {
    source = "install.sh"
    destination = "/tmp/install.sh"
}

provisioner "file" {
    source = "remove.sh"
    destination = "/tmp/remove.sh"
}

provisioner "shell" {
    inline = ["sudo bash /tmp/remove.sh", "rm -f /tmp/remove.sh"]
  }

provisioner "shell" {
    inline = ["sudo bash /tmp/install.sh", "rm -f /tmp/install.sh"]
  }
}
