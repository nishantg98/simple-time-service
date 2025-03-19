terraform {
            backend "s3" {
              bucket         = "simple-time-service-tf-state"
              key            = "terraform.tfstate"
              region         = "us-east-1"
              encrypt        = true
              dynamodb_table = "terraform-locks"
            }
          }