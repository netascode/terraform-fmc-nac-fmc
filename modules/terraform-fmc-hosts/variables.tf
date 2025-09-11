variable "hosts" {
  description = "List of FMC hosts"
  type = list(object({
    name        = string
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "domain" {
  description = "FMC Domain name in which hosts should be created"
  type        = string
  default     = "Global"
}

variable "bulk" {
  description = "Enable bulk host creation"
  type        = bool
  default     = false
}
