#!/bin/bash
      sudo yum update -y
      sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
      sudo yum install -y httpd mariadb-server
      sudo systemctl start httpd
      sudo systemctl enable httpd
      sudo usermod -a -G apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
