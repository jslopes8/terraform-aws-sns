resource "aws_sns_topic_policy" "main" {
  count = var.create ? length(var.access_policy) : 0

  arn    = aws_sns_topic.main.0.arn
  policy = data.aws_iam_policy_document.main.0.json
}