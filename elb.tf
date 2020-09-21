resource "aws_lb" "wiki-lb" {
  name            = "wiki-lb"
  load_balancer_type = "application"
  internal           = false
  subnets         = [aws_subnet.wiki-public-1.id, aws_subnet.wiki-public-2.id]
  security_groups = [aws_security_group.wiki-lb-sg.id]
  tags = {
    Name = "wiki-lb"
  }
}

resource "aws_lb_target_group" "wiki-tg" {
  name     = "wiki-demo-lb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.wiki.id
  health_check {
    path     = "/resources/assets/mediawiki.png"
    protocol = "HTTP"
    matcher  = "200"
  }
}


resource "aws_lb_listener" "wiki-lb-listener" {
  load_balancer_arn = aws_lb.wiki-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wiki-tg.arn
  }
}
