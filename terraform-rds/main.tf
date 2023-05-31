data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = "prod/test/rds"
}



resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             =  "admin"
  password             =  data.aws_secretsmanager_secret_version.rds_password.secret_string
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}