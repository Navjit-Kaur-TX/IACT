terraform {
  backend "s3"{
    bucket = "demoiact2"
    encrypt = true
    key = "terraform.tfstate"
    region = "us-west-2"
  }
}
provider "aws" {
    region = "us-west-2"
}