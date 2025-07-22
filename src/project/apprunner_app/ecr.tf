resource "aws_ecr_repository" "user_front_ecr" {
  name                 = "user-front-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true


  encryption_configuration {
    encryption_type = "AES256"
  }
}
