module "backend_bucket" {

  source = "./s3-backend"

  bucket_name = "abhinov-tfstate-prod"

  environment = "shared"
}

module "lock_table" {

  source = "./dynamodb-lock"

  table_name = "terraform-state-lock"
}