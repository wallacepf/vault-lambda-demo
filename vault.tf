provider "vault" {
  address   = var.hcp_vault
  token     = var.hcp_vault_token
  namespace = var.hcp_vault_namespace
}

resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_auth_backend_client" "aws-creds" {
  backend    = vault_auth_backend.aws.path
  access_key = aws_iam_access_key.aws-accesskey-for-vault-authmethod.id
  secret_key = aws_iam_access_key.aws-accesskey-for-vault-authmethod.secret
}

resource "vault_aws_auth_backend_role" "lambda-demo" {
  backend                  = vault_auth_backend.aws.path
  role                     = aws_iam_role.lambda.name
  auth_type                = "iam"
  bound_iam_principal_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.lambda.name}"]
  token_policies           = [vault_policy.vault-demo-lambda.name]
    depends_on = [
      aws_iam_user.aws-iamuser-for-vault-authmethod,
      aws_iam_user_policy.aws-policy-for-vault-authmethod,
      aws_iam_access_key.aws-accesskey-for-vault-authmethod
    ]
}

data "aws_caller_identity" "current" {
}

resource "vault_kv_secret_v2" "vault-demo-lambda" {
  mount = "secret"
  name  = "vault-lambda-demo"
  data_json = jsonencode(
    {
      username = "myvault",
      password = "123abcP@ssw0rd"
    }
  )
}

resource "vault_policy" "vault-demo-lambda" {
  name = "vault-demo-lambda"

  policy = <<EOT
path "secret/data/vault-lambda-demo" {
  capabilities = ["read"]
}
EOT
}

