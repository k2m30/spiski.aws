terraform {
  required_providers {
    aws = {
      version = "~> 5.20.0"
    }
    archive = {
      version = "~> 2.4.0"
    }
  }
  required_version = "~> 1.5"
}

#rdMH9[RA

provider "aws" {
  profile = "personal"
  region  = "eu-central-1"
}

