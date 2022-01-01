variable "create" {
  type    = bool
  default = true
}
variable "topic_name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "display_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = null
}
variable "kms_master_key" {
  type        = string
  description = "(optional) describe your variable"
  default     = null
}
variable "access_policy" {
  type    = any
  default = []
}
variable "subscription" {
  type    = any
  default = []
}
variable "default_tags" {
    type = map(string)
    default = {} 
}