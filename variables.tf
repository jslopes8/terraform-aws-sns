variable "create" {
    type = bool
    default = true
}
variable "default_tags" {
    type = map(string)
    default = {} 
}
variable "subscriptions_endpoint" {
    type = any
    default = []
}
variable "topic_standard" {
    type = any
    default = []
}