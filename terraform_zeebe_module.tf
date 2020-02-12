resource "aws_lambda_function" "lambda" {
  function_name                  = var.function_name
  handler                        = var.handler
  runtime                        = var.runtime
  filename                       = var.filename
  source_code_hash               = var.source_code_hash
  role                           = var.role_arn
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions

  environment {
    variables = merge(
      var.environment_variables,
      {
        ZEEBE_FULFILLER_SNS_ARN = data.aws_sns_topic.zeebe_jobs2complete.arn
      }
    )
  }

  layers = var.layers
}


resource "aws_sns_topic_subscription" "lambda" {
  topic_arn     = data.aws_sns_topic.zeebe_jobs.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.lambda.arn
  filter_policy = "${jsonencode(map("lambdaIdentifier", list(aws_lambda_function.lambda.function_name)))}"
}
