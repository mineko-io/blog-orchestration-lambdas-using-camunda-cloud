resource "aws_sqs_queue" "lambda" {
  name                       = "zeebe_${aws_lambda_function.lambda.function_name}"
  visibility_timeout_seconds = aws_lambda_function.lambda.timeout * 6
  redrive_policy             = "{\"deadLetterTargetArn\":\"${data.aws_sqs_queue.dlq.arn}\",\"maxReceiveCount\":1}"
}
