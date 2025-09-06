variable "aws_region" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "image_uri" {}
variable "alert_email" {}


