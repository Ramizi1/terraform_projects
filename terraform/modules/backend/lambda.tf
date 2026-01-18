# Archive Python code for Lambda
data "archive_file" "visitor_count" {
  type        = "zip"
  source_file = "${path.root}/backend/update_count.py"
  output_path = "${path.module}/update_count_function.zip"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach custom DynamoDB policy
resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# Attach basic Lambda logging policy
resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy to access DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda_dynamodb_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.visitor_count.arn
      }
    ]
  })
}

# Lambda function
resource "aws_lambda_function" "lambda_visitor_count" {
  filename      = data.archive_file.visitor_count.output_path
  function_name = "lambda_visitor_count"
  role          = aws_iam_role.lambda_role.arn
  handler       = "update_count.lambda_handler"
  runtime       = "nodejs20.x"

  environment {
    variables = {
      LOG_LEVEL = "info"
    }
  }

  tags = {
    Application = "visitor_count"
  }
}