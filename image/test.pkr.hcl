packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "test" {
  ami_name      = "packer-test"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  security_group_id = "sg-00609f32ed4da143e"
  ssh_keypair_name = "kpetrov"
  ssh_private_key_file = "~/.ssh/kpetrov.pem"
  associate_public_ip_address = "true"
  source_ami = "ami-0e2031728ef69a466"
  vpc_id = "vpc-3698fe5c"
  subnet_id = "subnet-07e4d4dbd22ab93b9"
  ssh_username = "ec2-user"
}

build {
  name    = "packer-test"
  sources = [
    "source.amazon-ebs.test"
  ]
provisioner "file" {
    source = "install.sh"
    destination = "/tmp/install.sh"
}


provisioner "file" {
    source = "packages_to_install.txt"
    destination = "/tmp/packages_to_install.txt"
}

provisioner "file" {
    source = "packages_to_delete.txt"
    destination = "/tmp/packages_to_delete.txt"
}

provisioner "file" {
    source = "remove.sh"
    destination = "/tmp/remove.sh"
}

provisioner "shell" {
    inline = ["sudo bash /tmp/install.sh", "rm /tmp/install.sh"]
}

provisioner "shell" {
    inline = ["sudo bash /tmp/remove.sh", "rm /tmp/remove.sh"]
}

}
