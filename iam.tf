resource "aws_iam_role" "lambda" {
  name               = "${var.environment_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${var.environment_name}-lambda-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "LambdaLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_user" "aws-iamuser-for-vault-authmethod" {
  name = "aws-iamuser-for-vault-authmethod"
}

resource "aws_iam_user_policy" "aws-policy-for-vault-authmethod" {
  user = aws_iam_user.aws-iamuser-for-vault-authmethod.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "iam:GetUser",
          "iam:ListRoles",
          "iam:GetRole"
        ],
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "aws-accesskey-for-vault-authmethod" {
  user = aws_iam_user.aws-iamuser-for-vault-authmethod.name
}

data "aws_iam_policy_document" "aws-iampolicy-for-vault-authmethod" {
  statement {
    sid    = "aws-iampolicy-for-vault-authmethod"
    effect = "Allow"

    actions = [
     "ec2:DescribeInstances",
     "iam:GetInstanceProfile",
     "iam:GetUser",
     "iam:ListRoles",
     "iam:GetRole"
    ]

    resources = ["*"]
  }
}