data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_sub.id
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public_instance"
  }
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'EC2 instance is ready.'",
      "mkdir src"
    ]

  }
  provisioner "file" {
    source      = "../nodejsapp/src/package.json"
    destination = "src/package.json"
  }
  provisioner "file" {
    source      = "../nodejsapp/src/server.js"
    destination = "src/server.js"
  }
  provisioner "file" {
    source      = "../nodejsapp/Dockerfile"
    destination = "Dockerfile"
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("${path.module}/${var.key_name}.pem")
    }
}
data "template_file" "inventory" {
  depends_on = [aws_instance.public_instance]
  template = <<-EOT
    [ec2_instances]
    ${aws_instance.public_instance.public_ip} ansible_user=ubuntu ansible_private_key_file=${path.module}/${var.key_name}.pem
    EOT
}

resource "local_file" "dynamic_inventory" {
  depends_on = [aws_instance.public_instance]

  filename = "dynamic_inventory.ini"
  content  = data.template_file.inventory.rendered
  file_permission = 0400
}

resource "terraform_data" "run_ansible" {
  depends_on = [local_file.dynamic_inventory]

  provisioner "local-exec" {
    command = "ansible-playbook -v -i dynamic_inventory.ini deploy-app.yaml"
    working_dir = path.module
  }
}
output "publicip-ec2" {
  value = "Congrats! Your Node app is running on ${aws_instance.public_instance.public_ip}:3000"
}