terraform {
  cloud {
    organization = "heder24"

    workspaces {
      name = "knbte-app-wkspace"
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

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       # This requires the awscli to be installed locally where Terraform is executed
#       args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#     }
#   }
# }

# provider "kubernetes" {
#   host                   = data.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)


#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", data.eks.cluster_name]
#   }

# }

# data "aws_region" "current" {}


# output "eks_cluster_name" {
#   value = module.aws_eks_cluster.prod.name
# }

# output "eks_cluster_endpoint" {
#   value = module.aws_eks_cluster.prod.endpoint
# }

# output "eks_cluster_certificate_authority_data" {
#   value = module.aws_eks_cluster.prod.certificate_authority[0].data
# }

# output "eks_cluster_arn" {
#   value = module.aws_eks_cluster.prod.arn
# }


# provider "kubernetes" {
#   experiments {
#     manifest_resource = true
#   }
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     token                  = data.aws_eks_cluster_auth.cluster.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   }
# }


data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "heder24"

    workspaces = {
      name = "kNtzzzTe-wkspace"
    }
  }
}

data "aws_caller_identity" "current" {}
# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name",data.aws_eks_cluster.cluster.name]
    command     = "aws"
  
  }
  
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}
