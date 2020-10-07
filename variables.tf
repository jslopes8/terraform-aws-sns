variable "create" {
    type = bool
    default = true
}
variable "stack_name" {
    type = string
}
variable "display_name" {
    type = string
}
variable "email_address" {
    type = string
}
variable "protocol" {
    type = string
}
variable "default_tags" {
    type = map(string)
    default = {} 
}