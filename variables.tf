variable "yaml_directories" {
  description = "List of paths to YAML directories."
  type        = list(string)
  default     = ["data"]
}

variable "yaml_files" {
  description = "List of paths to YAML files."
  type        = list(string)
  default     = []
}

variable "model" {
  description = "As an alternative to YAML files, a native Terraform data structure can be provided as well."
  type        = map(any)
  default     = {}
}

variable "deploy_support" {
  description = "Enables support for FTD deployments"
  type        = bool
  default     = true
}

variable "write_default_values_file" {
  description = "Write all default values to a YAML file. Value is a path pointing to the file to be created."
  type        = string
  default     = ""
}

variable "yaml_existing_file" {
  description = "Path to file with the list of pre-configured FMC objects"
  type        = string
  default     = "data/existing/existing.yaml"
}

variable "FMC_USERNAME" {
  description = "FMC Username"
  type        = string
  default     = null
}

variable "FMC_PASSWORD" {
  description = "FMC Password"
  type        = string
  default     = null
}
