output "sns_arn" {
  value = aws_sns_topic.main.0.arn
}
output "sns_id" {
  value = aws_sns_topic.main.0.id
}