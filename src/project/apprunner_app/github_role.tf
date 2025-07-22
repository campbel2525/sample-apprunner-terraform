# ----------------------------------------------------------------
# 3. GitHub Actions用 OIDC連携ロール
#    - GitHub ActionsがAWS APIを操作（デプロイ開始）するためのロール
# ----------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.github_fingerprint]
}

resource "aws_iam_role" "github_actions_role" {
  name = "apprunner-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" : var.github_subject
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_apprunner_policy" {
  name        = "GitHubActions-AppRunnerECRLambdaPolicy"
  description = "Allows GitHub Actions to build/push to ECR, deploy to App Runner, and update/invoke Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR へのプッシュ・プル権限
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = [aws_ecr_repository.user_front_ecr.arn]
      },
      # ECR 認証トークン取得権限
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      # App Runner へのデプロイ権限
      {
        Effect = "Allow"
        Action = [
          "apprunner:StartDeployment",
          "apprunner:DescribeService"
        ]
        Resource = module.user_front_apprunner.apprunner_arn
      },
      # Lambda 関数のコード更新・実行権限
      {
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:InvokeFunction"
        ]
        Resource = aws_lambda_function.migration_lambda.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_apprunner_policy.arn
}
