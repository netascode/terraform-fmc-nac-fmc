<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco FMC Module

A Terraform module to configure Cisco FMC.

## Usage

This module supports an inventory driven approach, where a complete FMC configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Examples

Configuring a Network Access Condition using YAML:

#### `host.yaml`

```yaml
---
fmc:
  name: MyFMC1
  hostname: 10.62.158.76
  domain:
  - name: Global
    host:
    - name: MyHost1
      value: 10.10.10.10
```

#### `main.tf`

```hcl
module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"

  yaml_files = ["host.yaml"]
}
```

## Requirements

No requirements.
## Inputs

No inputs.
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Resources

No resources.
## Modules

No modules.
<!-- END_TF_DOCS -->