<!-- BEGIN_TF_DOCS -->
# FMC Network Group Object Example

This example will create a new `MyNetworkGroup1` network-group object that contains two objects:
- newly created `MyHost1` host object
- already existing `any-ipv4` network object 

Set environment variables pointing to FMC:

```bash
export FMC_USERNAME=<username>
export FMC_PASSWORD=<password>
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply \
  -target=module.fmc.local_file.access_rule \
  -target=module.fmc.local_file.networkgroups \
  -target=module.fmc.local_file.ftdmanualnatrule \
  -target=module.fmc.local_file.deploy
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `data/fmc.yaml`

```yaml
---
fmc:
  name: MyFMC1
  hostname: 10.1.1.1
  domains:
  - name: Global
    hosts:
    - name: MyHost1
      value: 10.10.10.10
    network_groups:
    - name: MyNetworkGroup1
      objects:
      - MyHost1
      - any-ipv4
```

#### `data/existing/existing.yaml`

```yaml
---
fmc:
  domains:
  - name: Global
    networks:
    - name: any-ipv4
```

#### `main.tf`

```hcl
module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"
}
```
<!-- END_TF_DOCS -->