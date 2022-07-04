variable "network_application" {
  description = "Network Application"
  nullable    = false
  type        = object({
    security_group = string
    subnet         = string
  })
}

variable "network_database" {
  description = "Network Database"
  nullable    = false
  type        = object({
    security_group = string
    subnet         = string
  })
}
