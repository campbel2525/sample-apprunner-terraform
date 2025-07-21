# ---------------------------------------------
# db_sg
# ---------------------------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "db-sg"
  }
}
resource "aws_security_group_rule" "db_in_app" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app.id
}
resource "aws_security_group_rule" "db_out_all" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
# Lambdaからの入口を許可するルール
resource "aws_security_group_rule" "db_in_from_lambda" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.lambda_sg.id
  description              = "Allow inbound from Migration Lambda"
}

# ---------------------------------------------
# app
# ---------------------------------------------
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "app role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "app-sg"
  }
}
resource "aws_security_group_rule" "app_out_all" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# lambda
# ---------------------------------------------
resource "aws_security_group" "lambda_sg" {
  name        = "migration-lambda-sg"
  description = "Security group for migration Lambda"
  vpc_id      = aws_vpc.vpc.id # main.idはご自身のVPCに合わせてください

  tags = {
    Name = "lambda-sg"
  }
}
# LambdaからDBへの出口ルール
resource "aws_vpc_security_group_egress_rule" "lambda_out_to_db" {
  security_group_id            = aws_security_group.lambda_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.db_sg.id
  description                  = "Allow outbound to DB SG"
}
