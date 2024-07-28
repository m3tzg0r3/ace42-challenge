terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "ace42-local"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "ace42-local"
  }
}
