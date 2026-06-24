#Bastion Host
resource "aws_instance" "bastion" {

  ami                    = var.ami_id

  instance_type          = var.instance_type

  subnet_id              = var.public_subnet_id

  key_name               = var.key_name

  vpc_security_group_ids = [
    var.bastion_sg_id
  ]

  associate_public_ip_address = true

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  root_block_device {

    encrypted = true

    volume_size = 20

    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion"
  }
}

#Web Server
resource "aws_instance" "web" {

  ami                    = var.ami_id

  instance_type          = var.instance_type

  subnet_id              = var.public_subnet_id

  key_name               = var.key_name

  vpc_security_group_ids = [
    var.web_sg_id
  ]

  associate_public_ip_address = true

  user_data = file("${path.module}/userdata/nginx.sh")

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  root_block_device {

    encrypted = true

    volume_size = 20

    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web"
  }
}

#Application Server
resource "aws_instance" "app" {

  ami                    = var.ami_id

  instance_type          = var.instance_type

  subnet_id              = var.private_subnet_id

  key_name               = var.key_name

  vpc_security_group_ids = [
    var.app_sg_id
  ]

  associate_public_ip_address = false

  user_data = file("${path.module}/userdata/app.sh")

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"
  }

  root_block_device {

    encrypted = true

    volume_size = 20

    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-app"
  }
}
