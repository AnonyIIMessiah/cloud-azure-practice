variable "location" {
  default = "centralindia"
}

variable "resource_group_name" {
  default = "yc-basics-rg-12345-tf"
}

variable "storage_account_name" {
  default = "week7staticsite12345"
}

variable "subscription_id" {
  description = "The Subscription ID to deploy resources into"
  type        = string
}