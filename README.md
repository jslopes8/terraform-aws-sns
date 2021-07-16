# AWS EventBrigde Terraform Modules

O codigo irá prover os seguintes recursos na AWS.

* [SNS Topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)
* [SNS Topic Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy)
* [Cloudformation Stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack)

## Usage
```bash
module "sns_topic" {
  source = "git::https://github.com/jslopes8/terraform-aws-sns.git?ref=v1.0"

  subscriptions_endpoint = [{
    name          = local.stack_name
    display_name  = "${local.stack_name} - Notification"
    protocol      = "lambda"
    endpoint      = module.create_lambda.arn

    ## This policy defines who can access your topic. 
    ## By default, only the topic owner can publish or subscribe to the topic.
    access_policy = [
      {
        sid     = "__default_statement_ID"
        effect  = "Allow"
        principals = {
          type  = "AWS"
          identifiers = ["*"]
        }
        actions = [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish",
          "SNS:Receive"
        ]
        resources = [
          "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:${local.stack_name}*" 
        ]
        condition = {
          test      = "StringEquals"
          variable  = "AWS:SourceOwner"
          values    = [ data.aws_caller_identity.current.account_id ]
        }
      },
      {
        sid = "AWSEvents"
        effect = "Allow"
        principals = {
          type = "Service"
          identifiers = ["events.amazonaws.com"]
        }
        actions = ["sns:Publish"]
        resources = ["arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:${local.stack_name}*"]
      }
    ]
  }]

  default_tags = local.default_tags
}
```

## Requirements
| Name | Version |
| ---- | ------- |
| aws | ~> 3.1 |
| terraform | ~> 0.14 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| subscriptions_endpoint | O bloco de argumento para criação do SNS topic. Segue abaixo mais detalhes. | `no` | `list` | `[ ]` |
| default_tags | Block de chave-valor que fornece o taggeamento para todos os recursos criados em sua VPC. | `no` | `map` | `{}` |

O argumento `subscriptions_endpoint` possui os seguintes atributos;
- `name` - (Obrigatorio) O nome do Topic.
- `display_name` (Obrigatorio) O nome de exibição do topic.
- `protocol` - (Obrigatorio) Protocolo a ser usado. Os valores válidos são: `sqs`, `sms`, `lambda`, `firehose`, `application`, `email`, `email-json`, `http` e `https`.
- `endpoint` - (Obrigatorio) Endpoint para o qual enviar dados. O conteúdo varia de acordo com o protocolo.
- `access_policy`- (Opcional)  Um IAM Document para definir quem pode acessar seu tópico.

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| arn | O ARN do SNS topic |