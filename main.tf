####  2  #####
resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-alb-sg"
  description = "${var.name}-${var.env}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr # We are allowing app subnet to this instance to access
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-${var.env}-alb"  },    var.tags)
}

# This is the basic start for the load balancer
####  1  #####
resource "aws_lb" "main" {
  name               = "${var.name}--${var.env}-alb"
  internal           = var.internal # false
  load_balancer_type = var.load_balancer_type #"application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets

  tags = merge({
    Name = "${var.name}-${var.env}-alb"  },    var.tags)
}

##### 3 #####

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.port #"443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:968585591903:certificate/5532a382-c482-4c66-9f6a-d6a7c5395b38"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default error"
      status_code  = "500"
    }
  }
}

#resource "aws_lb_listener" "public" {
#  count             = var.name == "public" ? 1 : 0
#  load_balancer_arn = aws_lb.main.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
#
#resource "aws_lb_listener" "private" {
#  count             = var.name == "private" ? 1 : 0
#  load_balancer_arn = aws_lb.main.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type = "fixed-response"
#
#    fixed_response {
#      content_type = "text/plain"
#      message_body = "Default Error"
#      status_code  = "500"
#    }
#  }
#}


