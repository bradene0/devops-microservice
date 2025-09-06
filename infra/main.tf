resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.app_name}-ecs-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "app" {
  name = "${var.app_name}-cluster"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.app_name}-logs-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# optional: small RDS just to show persistence
resource "aws_db_instance" "app" {
  identifier         = "${var.app_name}-db"
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  username           = "demo"
  password           = "demo12345!"
  skip_final_snapshot = true
  publicly_accessible = true
}

# IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.app_name}-ecs-task-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

