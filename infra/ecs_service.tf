resource "aws_ecs_service" "app" {
  name            = "demo-app-service"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "demo-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}

