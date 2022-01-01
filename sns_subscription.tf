resource "aws_sns_topic_subscription" "main" {
  count = var.create ? length(var.subscription) : 0

  topic_arn              = aws_sns_topic.main.0.arn
  protocol               = lookup(var.subscription[count.index], "protocol", null)
  endpoint               = lookup(var.subscription[count.index], "endpoint", null)
  endpoint_auto_confirms = lookup(var.subscription[count.index], "auto_confirms", "true")
}