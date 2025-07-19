# ----------------------------------------------------------------
# 3. GitHub Actions用 OIDC連携ロール
#    - GitHub ActionsがAWS APIを操作（デプロイ開始）するためのロール
# ----------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # 最新のThumbprintは公式ドキュメントで確認してください
  thumbprint_list = [var.github_fingerprint]
}

# GitHub Actionsが引き受けるためのロール
resource "aws_iam_role" "github_actions_role_user_front" {
  name = "user-front-apprunner-github-actions-role"

  # OIDCプロバイダー経由での引き受けを許可
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" : var.github_subject
          }
        }
      }
    ]
  })
}
resource "aws_iam_policy" "github_actions_apprunner_policy" {
  # ポリシー名をより明確に変更することを推奨します
  name        = "GitHubActions-AppRunnerECRDeploymentPolicy"
  description = "Allows GitHub Actions to build, push to ECR, and deploy to App Runner"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # # App Runner へのデプロイ権限 (既存)
      # {
      #   Effect = "Allow"
      #   Action = [
      #     "apprunner:StartDeployment",
      #     "apprunner:DescribeService"
      #   ]
      #   Resource = module.user_front_apprunner.apprunner_arn
      # },
      # ECR へのイメージプッシュ権限 (追加が必要)
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
        # ここには、GitHub Actions がイメージをプッシュするすべてのECRリポジトリのARNを列挙する必要があります。
        # 例: ステージングと本番で異なるリポジトリを使用する場合
        Resource = [
          module.user_front_apprunner.ecr_arn,
          # "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/your-prod-app-ecr-repo"
        ]
      },
      # ECR 認証トークン取得権限 (追加が必要、通常はすべてのECRリポジトリに対して許可)
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role       = aws_iam_role.github_actions_role_user_front.name
  policy_arn = aws_iam_policy.github_actions_apprunner_policy.arn
}
