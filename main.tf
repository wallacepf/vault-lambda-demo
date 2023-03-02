provider "aws" {}

output "hcp-vault-secretaccesskey" {
  value = aws_iam_access_key.aws-accesskey-for-vault-authmethod.secret
  sensitive = true
}

output "hcp-vault-accesskey" {
  value = aws_iam_access_key.aws-accesskey-for-vault-authmethod.id
}

resource "aws_lambda_function" "function" {
  function_name = "${var.environment_name}-function"
  description   = "Demo Vault AWS Lambda extension"
  role          = aws_iam_role.lambda.arn
  filename      = "demo-function.zip"
  handler       = "main"
  runtime       = "provided.al2"
  layers        = ["arn:aws:lambda:${var.aws_region}:634166935893:layer:vault-lambda-extension:15"]

  environment {
    variables = {
      VAULT_ADDR          = var.hcp_vault,
      VAULT_AUTH_ROLE     = aws_iam_role.lambda.name,
      VAULT_AUTH_PROVIDER = "aws",
      VAULT_SECRET_PATH   = "secret/data/vault-lambda-demo",
      VAULT_NAMESPACE     = "admin"
    }
  }
}