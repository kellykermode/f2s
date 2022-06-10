# Create the security group for web server
resource "aws_security_group" "test-web" {
  name = "test-web"
  description = "Security Group for Web Server"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-web"
  }
}

# Create an EC2 instance
resource "aws_instance" "web" {
  # AMI ID for CentOS
  ami           = "${var.ami}"
  instance_type = "t2.micro"
  key_name      =  "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.test-web.id}"]
  subnet_id = "${var.subnet_id}"

  tags = {
    Name = "Web"
    CR = "SHUTDOWN"
  }
  user_data = <<-EOF
      #!/bin/sh
      sudo yum update -y
      sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
      sudo yum install -y httpd mariadb-server
      sudo systemctl start httpd
      sudo systemctl enable httpd
      sudo usermod -a -G apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
      EOF
}
