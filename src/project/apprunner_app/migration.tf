# ---------------------------------------------
# Lambda関数 本体
# ---------------------------------------------
resource "aws_lambda_function" "migration_lambda" {
  function_name    = "database-migration-lambda"
  role             = aws_iam_role.lambda_exec_role.arn
  filename         = "index.js.zip"
  source_code_hash = filebase64sha256("index.js.zip")

  # 実行環境の設定
  handler = "index.handler" # zip内のハンドラに合わせてください
  runtime = "nodejs22.x"

  # タイムアウト
  timeout = 300

  # VPC設定
  vpc_config {
    subnet_ids = [
      module.private_subnet_1a.id,
      # module.private_subnet_1c.id,
    ]
    security_group_ids = [module.lambda_sg.id]
  }

  # 環境変数
  environment {
    variables = {
      DB_HOST = module.rds.endpoint
      DB_USER = var.db_init_username
    }
  }

  tags = {
    Name = "database-migration-lambda"
  }
}

# ---------------------------------------------
# Lambda実行用のIAMロール
# ---------------------------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "database-migration-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "database-migration-lambda-role"
  }
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
