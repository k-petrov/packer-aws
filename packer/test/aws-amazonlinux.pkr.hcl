packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "test" {
  ami_name      = "packer-test-frontend"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  security_group_id = "sg-09d9ded17f8af628a"
  ssh_keypair_name = "pavel_m_laptop"
  ssh_private_key_file = "~/.ssh/amazon.pem"
  associate_public_ip_address = "false"
  source_ami = "ami-0dcc0ebde7b2e00db"
  vpc_id = "vpc-0e184ddf70dbf8f32"
  subnet_id = "subnet-098f03ca795cf3b87"
  ssh_username = "ec2-user"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.test"
  ]
provisioner "file" {
    source = "provision.sh"
    destination = "~/provision.sh"
}
provisioner "shell" {
    inline = ["sudo bash ~/provision.sh", "rm ~/provision.sh"]
  }
}
