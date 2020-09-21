data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_launch_configuration" "wiki-launchconfig" {
  name_prefix     = "wiki-launchconfig"
  image_id        = data.aws_ami.centos.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.wiki-ec2-sg.id]
  user_data       = "#!/bin/bash\nyum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm epel-release;yum-config-manager --enable remi-php73;yum -y install httpd php php-mysql php-pdo php-gd php-mbstring php-xml php-intl texlive wget vim;systemctl start httpd; systemctl enable httpd;wget https://releases.wikimedia.org/mediawiki/1.32/mediawiki-1.32.0.tar.gz -P /var/www/html/;sleep 5;cd /var/www/html/;tar xf  mediawiki*.tar.gz; mv mediawiki-1.32.0/* /var/www/html/ ;setenforce 0"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wiki-autoscaling" {
  name                      = "wiki-autoscaling"
  vpc_zone_identifier       = [aws_subnet.wiki-public-1.id, aws_subnet.wiki-public-2.id]
  launch_configuration      = aws_launch_configuration.wiki-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 700
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.wiki-tg.arn]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}

