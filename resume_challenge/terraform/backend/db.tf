resource "aws_dynamodb_table" "visitor_count" {
  name           = "visitor_count"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Name        = "visitor count table"
  }
}
