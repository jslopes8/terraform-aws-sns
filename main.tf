data "template_file" "main" {
  count = var.create ? length(var.subscriptions_endpoint) : 0

  template = file("${path.module}/templates/cf-sns-stack.tpl")
  vars = {
    display_name  = lookup(var.subscriptions_endpoint[count.index], "display_name", null)
    endpoint      = lookup(var.subscriptions_endpoint[count.index], "endpoint", null)
    protocol      = lookup(var.subscriptions_endpoint[count.index], "protocol", null)
  }
}

#
# CF Stack for Endpoint EMAIL/HTTPS/HTTP and LAMBDA (templates/cf-sns-stack.tpl)
#
resource "aws_cloudformation_stack" "main" {
  count = var.create ? length(var.subscriptions_endpoint) : 0

  name          = lookup(var.subscriptions_endpoint[count.index], "name", null)
  template_body = data.template_file.main.0.rendered
  tags          = merge({
    "Name" = lookup(var.subscriptions_endpoint[count.index], "name", null) }, var.default_tags
  )
}

#
# SNS Topic
#

resource "aws_sns_topic" "main" {
  count = var.create ? length(var.topic_standard) : 0

  name            = lookup(var.topic_standard[count.index], "name", null)
  display_name    = lookup(var.topic_standard[count.index], "display_name", null)
  tags            = merge({
    "Name" = lookup(var.topic_standard[count.index], "name", null) }, var.default_tags
  )
}

#
# SNS Topic Policy
#
resource "aws_sns_topic_policy" "main" {
  count = var.create && length(var.subscriptions_endpoint) > 0 ? length(var.subscriptions_endpoint) : 0

  arn = aws_cloudformation_stack.main.0.outputs["ARN"]
  policy = data.aws_iam_policy_document.main.0.json
}

#
# IAM Document - For SNS Topic Policy
#

data "aws_iam_policy_document" "main" {
  count = var.create ? length(var.subscriptions_endpoint) : 0

    dynamic "statement" {
      for_each = lookup(var.subscriptions_endpoint[count.index], "access_policy", null)
      content {
        sid         = lookup(statement.value, "sid", null)
        effect      = lookup(statement.value, "effect", null)
        actions     = lookup(statement.value, "actions", null)
        resources   = lookup(statement.value, "resources", null)

        dynamic "condition" {
          for_each = length(keys(lookup(statement.value, "condition", {}))) == 0 ? [] : [lookup(statement.value, "condition", {})]
          content {
            test      = lookup(condition.value, "test", null)
            variable  = lookup(condition.value, "variable", null)
            values    = lookup(condition.value, "values", null)
          }
        }
        dynamic "principals" {
          for_each = length(keys(lookup(statement.value, "principals", {}))) == 0 ? [] : [lookup(statement.value, "principals", {})]
          content {
            type        = lookup(principals.value, "type", null)
            identifiers = lookup(principals.value, "identifiers", null)
          }
        }
      }
    }
}