provider "aws" {
  region = "us-east-1"
}

variable "environment" {
  description = "The environment to deploy (dev ou prod)"
  type        = string
}

# Data source para verificar roles existentes
data "aws_iam_role" "existing_role" {
  name = "lambda_exec_role_${var.environment}"
}

# Fun��o Lambda
resource "aws_lambda_function" "auth_function" {
  function_name    = "lambda_authorization_${var.environment}"
  handler          = "br.com.techchallenge.lambda.autorizer.LambdaAuthorizer::handleRequest"
  runtime          = "java11"
  role             = data.aws_iam_role.existing_role.arn
  filename         = "LambdaAuthorizer-2.0.0.jar"  # Especifica o arquivo JAR
  source_code_hash = filebase64sha256("LambdaAuthorizer-2.0.0.jar")

  environment {
    variables = {
      ENV = var.environment
    }
  }
}

# Role IAM para a fun��o Lambda
resource "aws_iam_role" "lambda_exec_role" {
  count = data.aws_iam_role.existing_role.name != "" ? 0 : 1

  name = "lambda_exec_role_${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      assume_role_policy
    ]
  }
}

# Anexar pol�tica � role IAM
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  count = data.aws_iam_role.existing_role.name != "" ? 0 : 1

  role       = aws_iam_role.lambda_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}