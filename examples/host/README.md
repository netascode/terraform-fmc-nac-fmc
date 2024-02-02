<!-- BEGIN_TF_DOCS -->
# FMC Host Object Example

Set environment variables pointing to FMC:

```bash
export FMC_USERNAME=admin
export FMC_PASSWORD=Cisco123
export FMC_HOST=https://10.1.1.1
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
module "ise" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"

  yaml_files = ["host.yaml"]
}
```
<!-- END_TF_DOCS -->