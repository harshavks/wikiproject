resource "aws_security_group" "wiki-ec2-sg" {
  vpc_id      = aws_vpc.wiki.id
  name        = "wiki-ec2-sg"
  description = "security group for my instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.wiki-lb-sg.id]
  }
  
  tags = {
    Name = "wiki-ec2-sg"
  }
}

resource "aws_security_group" "wiki-rds-sg" {
  vpc_id      = aws_vpc.wiki.id
  name        = "wiki-rds-sg"
  description = "security group for my instance"
 ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wiki-ec2-sg.id]
  }

  tags = {
    Name = "wiki-rds-sg"
  }
}



resource "aws_security_group" "wiki-lb-sg" {
  vpc_id      = aws_vpc.wiki.id
  name        = "wiki"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wiki"
  }
}


