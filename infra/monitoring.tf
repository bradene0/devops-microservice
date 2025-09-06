# SNS topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "ecs-alerts-topic"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email  
}

# ECS CPU alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "ecs-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Trigger when ECS CPU exceeds 70%"
  dimensions = {
    ClusterName = aws_ecs_cluster.demo.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

# ECS Memory alarm
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "ecs-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Trigger when ECS Memory exceeds 70%"
  dimensions = {
    ClusterName = aws_ecs_cluster.demo.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

