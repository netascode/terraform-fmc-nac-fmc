variable "hosts" {
  description = "List of FMC hosts"
  type        = list(any)
  default     = []
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
