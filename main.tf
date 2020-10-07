data "template_file" "main" {

    count = var.create ? 1 : 0

    template = file("${path.module}/templates/cf-sns-stack.tpl")

    vars = {
        display_name  = var.display_name
        email_address = var.email_address
        protocol      = var.protocol
    }
}

resource "aws_cloudformation_stack" "main" {
    count = var.create ? 1 : 0

    name          = var.stack_name
    template_body = data.template_file.main.0.rendered

    tags = merge(
        {
            "Name" = var.stack_name
        },
        var.default_tags
    )
}
