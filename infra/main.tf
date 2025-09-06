provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "demo" {
  name = var.cluster_name
}

