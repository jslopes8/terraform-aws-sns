# AWS SNS Terraform Modules

O codigo irá prover os seguintes recursos na AWS.

* [SNS Topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)
* [SNS Topic Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy)
* [Cloudformation Stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack)

### Requirements
| Name | Version |
| ---- | ------- |
| aws | ~> 3.1 |
| terraform | ~> 0.14 |

### Caso de uso
```bash
module "sns_topic" {
  source = "git::https://github.com/jslopes8/terraform-aws-sns.git?ref=v2.0"

  topic_name   = "sns-test-topic"
  display_name = "Test SNS Topic"

  subscription = [
    { protocol = "email", endpoint = "test-a@email.com" },
    { protocol = "email", endpoint = "test-b@email.com" },
    { protocol = "lambda", endpoint = module.function.arn }
  ]

  access_policy = [
    {
      actions = [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
      ]
      condition = {
        test     = "StringEquals"
        variable = "AWS:SourceOwner"
        values   = ["123456789000"]
      }
      principals = {
        type        = "AWS"
        identifiers = ["*"]
      }
      resources = ["arn:aws:sns:us-east-1:123456789000:sns-test-topic"]
    }
  ]

  default_tags = {
    Tag_1 = "Valor_1"
    Tag_2 = "Valor_2"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| topic_name | O nome do seu SNS Topic. | `yes` | `string` | ` ` |
| default_tags | O mapa de chave-valor para taggeamento dos recursos. | `yes` | `map` | `{}` |
| display_name | O nome de exibição do SNS Topic. | `no` | `string` | `null` |
| kms_master_key | O ARN de uma chave KMS personalizada (CMK) ou gerenciada pela AWS para o SNS Topic. | `no` | `string` | `null` |
| access_policy | Um bloco dinamico para a politica de acesso para o SNS Topic. | `no` | `list` | `[ ]` |
| subscription | Um bloco dinamico que prover um ou mais subscription para o SNS Topic. Mais detalhes abaixo. | `no` | `list` | `[ ]` |

#### O argumento `subscription` possui os seguintes atributos;
```
Se usar um protocolo parcialmente compatível e a assinatura não for confirmada, seja por confirmação automática ou por meios externos (por exemplo, clicando no link "Confirmar assinatura" em um e-mail), o Terraform não poderá excluir/cancelar a assinatura. A tentativa de destruir uma assinatura não confirmada removerá o recursos do Terraform state, mas não removerá da AWS.
```
**Protocolos parcialmente compatíveis:**<br>
**email** - Entrega de mensagens via SMTP. Um endereço de e-mail.<br>
**email-json** - Entrega de mensagens codificadas em JSON via SMTP. Um endereço de e-mail.<br>
**http** - Entrega de mensagens codificadas em JSON via HTTP POST. Uma url com `http://`.<br>
**https** - Entrega de mensagens codificadas em JSON via HTTPS POST. Uma url com `https://`.<br>


- `protocol` - (Obrigatorio) Protocolo a ser usado. Os valores válidos são: `sqs`, `sms`, `lambda`, `firehose`, `application`. Protocolos parcialmente compatíveis: `email`, `email-json`, `http` e `https`.
- `endpoint` - (Obrigatorio) Endpoint para o qual enviar dados. O conteúdo varia de acordo com o protocolo.

#### O argumento `access_policy` possui os seguintes atributos;<br>
```
Se um Principal for especificado apenas como um ID de conta AWS em vez de um ARN, a AWS silenciosamente o converte em ARN para o usuário root. por exemplo `arn:aws:iam::123456789000:root`
```
- `sid` (opcional) -  Inclua informação para diferenciar entre suas instruções.
- `effect` - Use `Allow` ou `Deny` para indicar se a política permite ou nega acesso.
- `principals` (Obrigatorio para este template) - Se você criar uma política baseada em recurso, deverá indicar a conta, o usuário, a função ou o usuário federado ao qual deseja permitir ou negar acesso.
  - `type` - O tipo de principal. Os valores válidos são `AWS`, `Service`, `Federated`, `CanonicalUser` e `*`.
  - `identifiers` - Lista de identificadores para o principal.
- `actions` - Inclua uma lista de ações que a política permite ou nega.
- `resources` - Inclua uma lista de recurso ao qual a ação se aplica.
- `condition` - Especifique as circunstâncias sob as quais a política concede a permissão.
  - `test` - Nome do operador de condição IAM a ser avaliado.
  - `variable`- O nome de uma variavel de contexto para aplicar na sua condição. As variáveis podem ser padrão da AWS começando com `aws:` ou variáveis específicas do serviço prefixadas com o nome do serviço.
  - `values` - Lista de valores para avaliar a condição. A AWS avalia vários valores como se estivesse usando uma operação booleana "OR".


## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| arn | O ARN do SNS topic |