terraform {
  cloud {
    organization = "heder24"

    workspaces {
     name = "kNNPX-wkspace"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
     
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    
    }
    grafana = {
      source = "grafana/grafana"
      version = "2.8.0"
    }    
}
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  # experiments {
  #   manifest_resource = true
  # }
  host                   = data.aws_eks_cluster.prod.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.prod.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.prod.token
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.prod.endpoint
    token                  = data.aws_eks_cluster_auth.prod.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.prod.certificate_authority[0].data)
  }
}




