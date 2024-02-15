data "aws_region" "current" {}

data "aws_eks_cluster" "prod" {
  name = "prod"
}

output "eks_cluster_name" {
  value = data.aws_eks_cluster.prod.name
}

output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.prod.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = data.aws_eks_cluster.prod.certificate_authority[0].data
}

output "eks_cluster_arn" {
  value = data.aws_eks_cluster.prod.arn
}
output "aws_eks_cluster_auth" {
  value =data.aws_eks_cluster_auth.prod.token
  sensitive = true
}
data "aws_eks_cluster_auth" "prod" {
  name = "prod"
}