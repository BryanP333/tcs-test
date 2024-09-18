module "ecs" {
  source                                     = "../../modules/ecs-cluster"
  pbs_name                                   = var.pbs_name
  main_subnet_ids              = ["subnet-0698ecf5deb906fce","subnet-015518ba9818266c3"]
  main_port                    = var.main_port
  credentialsParam                           = "arn:aws:secretsmanager:us-west-2:590183783078:secret:dockerhub-Jlkk90"
  container_image                            = "puenteb/tcs-test:latest"
  alb_arn = aws_lb_target_group.this.arn
  security_group = "sg-0a4be3e91286e2c0e"
}

resource "aws_lb" "this" {
  name                       = "${var.pbs_name}-main-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["sg-0a4be3e91286e2c0e"]
  subnets                    = ["subnet-0698ecf5deb906fce","subnet-015518ba9818266c3"]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name        = replace("${var.pbs_name}-main", "_", "-")
  port        = var.main_port
  protocol    = "HTTP"
  vpc_id      = "vpc-07fd24b9f32601e2a"
  target_type = "ip"

  health_check {
    enabled = true
    path    = "/health"
  }
 
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_ssm_parameter" "foo" {
  name  = "/${var.pbs_name}/alb/url"
  type  = "String"
  value = aws_lb.this.dns_name
}
