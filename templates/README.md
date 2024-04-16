<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco FMC Rule Resource Generator

A Terraform module to auto-generate Rule Resources.

## Usage

Go to `templates` folder and execute:


```bash
terraform init
terraform apply -var="supported_number_of_rules=200"
```
Where 200 is the new maximum number of supported rules.
<!-- END_TF_DOCS -->