locals {
  ecr_name = var.Ecr_repo_name
}
resource "aws_ecr_repository" "IaC_ecr_repo" {
  name = local.ecr_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

output "my_repo_url" {
  value = aws_ecr_repository.IaC_ecr_repo.repository_url
}
