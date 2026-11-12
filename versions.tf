terraform {
  required_version = ">= 1.8.0"

  required_providers {
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = ">= 2.8.0, < 2.9.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 2.0.0, < 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0, < 3.0.0"
    }
  }
}
