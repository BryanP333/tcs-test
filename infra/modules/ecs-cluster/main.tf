resource "aws_ecs_cluster" "main" {
  name               = "${var.pbs_name}-main"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
}

data "template_file" "main_container_def" {
  template = file("${path.module}/templates/main.json.tpl")

  vars = {
    name                    = "${var.pbs_name}-main"
    main_port               = var.main_port
    container_image         = "${var.container_image}"
    credentialsParam        = var.credentialsParam
  }
}

resource "aws_ecs_task_definition" "main" {
  family = var.pbs_name  
  task_role_arn            = "arn:aws:iam::590183783078:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::590183783078:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  container_definitions    = data.template_file.main_container_def.rendered

}

resource "aws_ecs_service" "main" {
  name = "${var.pbs_name}-main"

  task_definition        = aws_ecs_task_definition.main.arn
  cluster                = aws_ecs_cluster.main.id
  desired_count          = 2
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"
  enable_execute_command = true

  // Assuming we cannot have more than one instance at a time. Ever. 
  //deployment_maximum_percent         = 100
  //deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = var.alb_arn
    container_name   = "${var.pbs_name}-main"
    container_port   = var.main_port
  }

  network_configuration {
    subnets          = var.main_subnet_ids
    security_groups  = [var.security_group]
    assign_public_ip = true
  }
}