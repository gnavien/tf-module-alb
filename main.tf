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
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default error"
      status_code  = "500"
    }
  }
}


