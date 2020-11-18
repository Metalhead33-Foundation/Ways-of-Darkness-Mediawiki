terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.11.4"
    }

    vault = {
      source = "hashicorp/vault"
      version = "~> 2.12.0"
    }
  }
}