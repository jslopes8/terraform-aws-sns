output "arn" {
    value   = length(aws_cloudformation_stack.main) > 0 ? aws_cloudformation_stack.main.0.outputs : null
}
output "topic_arn" {
    value   = length(aws_sns_topic.main) > 0 ? aws_sns_topic.main.0.arn : null
}