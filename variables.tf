variable "aws_region" {
  default = "us-east-1"
}

variable "environment_name" {
  default = "vault-lambda-extension-demo"
}

variable "hcp_vault" {
  type = string
}

variable "hcp_vault_namespace" {
  type = string
}

variable "hcp_vault_token" {
  type = string
}