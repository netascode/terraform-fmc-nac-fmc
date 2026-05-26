terraform {
  required_version = ">= 1.8.0"

  required_providers {
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = ">= 2.3.0, < 3.0.0"
    }
    utils = {
      source  = "netascode/utils"
      version = "2.0.0-beta3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0, < 3.0.0"
    }
  }
}
