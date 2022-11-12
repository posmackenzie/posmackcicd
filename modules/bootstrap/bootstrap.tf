
# Build um S3 bucket para armazenar TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = var.name_of_s3_bucket

  # Tells AWS to encrypt the S3 bucket at rest by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Terraform  Destroy 
  lifecycle {
    prevent_destroy = true
  }

  # Versionamento
  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}

# DynamoDB para terraform state locking
resource "aws_dynamodb_table" "tf_lock_state" {
  name = var.dynamo_db_table_name

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.dynamo_db_table_name
    BuiltBy = "Terraform"
  }
}
