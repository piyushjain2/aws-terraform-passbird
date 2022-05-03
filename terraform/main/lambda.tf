data "template_file" "lambda_policy" {
  template                     = templatefile("${path.module}/iam/test_lambda.json.tpl",{})
}

resource "aws_iam_role" "lambda_alert_role" {
  name = "${local.env_id}-lambda-report-role"
  assume_role_policy = file(
  "${path.module}/iam/lambda_assume_role.json",
  )
}

resource "aws_iam_policy" "lambda_report_alert_policy" {
  name   = "${local.env_id}-lambda-report-alert"
  policy = data.template_file.lambda_policy.rendered
}

resource "aws_iam_policy_attachment" "lambda_report_alert_policy_attachment" {
  name       = "iam-role-attachment-${local.env_id}-lambda-report-alert"
  roles      = [aws_iam_role.lambda_alert_role.name]
  policy_arn = aws_iam_policy.lambda_report_alert_policy.arn
}

# Crete archive containing source
data "archive_file" "report_alert" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/report-alert"
  output_path = "./build/report-alert.zip"
}

# Create lambda function
resource "aws_lambda_function" "pb-lambda" {
  filename         = "./build/report-alert.zip"
  function_name    = "${local.env_id}-report-alert"
  role             = aws_iam_role.lambda_alert_role.arn
  handler          = "reportAlert.handler"
  source_code_hash = data.archive_file.report_alert.output_base64sha256
  timeout          = local.default_lambda_timeout
  runtime          = local.lambda_nodejs_runtime

  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [module.vpc.service_security_group_id]
  }
}