provider "aws" {
    region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "ipv4-app-tf-state"
    key    = "devel/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table  = "ipv4-app-tf-lock"
  }
}

module "app" {
    source = "../../"
    env_name = "devel" 
    app_name = "cidr-app"
    build_dir = "../../../build"    
}