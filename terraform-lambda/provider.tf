terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.13.0"
        }
        archive = {
            source = "hashicorp/archive"
            version = "2.2.0"
        }
    }
}

//Provide File
provider "aws" {
    region = "ap-south-1"
    //shared_credentials_files = ["C:/Users/Navjit kaur/.aws"]
}
