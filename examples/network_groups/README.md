<!-- BEGIN_TF_DOCS -->
# FMC Network Group Object Example

This example will create a new `MyNetworkGroup1`, `MyNetworkGroup2` network-group objects that contains two objects:
> `MyNetworkGroup1`:
- newly created `MyHost1` host object
- already existing `any-ipv4` network object 
> `MyNetworkGroup2`:
- newly created `MyNetworkGroup1` network-group object
- newly created `MyHost2` host object


Set environment variables pointing to FMC:

```bash
export FMC_USERNAME=<username>
export FMC_PASSWORD=<password>
export FMC_HOST=<hostname>
(Optionally)
export FMC_INSECURE_SKIP_VERIFY=true
```

To run this example you need to execute:

```bash
$ terraform init
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `data/existing.yaml`

```yaml
---
existing:
  fmc:
    domains:
    - name: Global
      objects:
        networks:
        - name: any-ipv4
```

#### `data/fmc.yaml`

```yaml
---
fmc:
  name: MyFMC1
  domains:
  - name: Global
    objects:
      hosts:
      - name: MyHost1
        ip: 10.10.10.10
      - name: MyHost2
        ip: 20.20.20.20        
      network_groups:
      - name: MyNetworkGroup1
        objects:
        - MyHost1
        - any-ipv4
      - name: MyNetworkGroup2
        objects:
        - MyNetworkGroup1
        - MyHost2
```

#### `main.tf`

```hcl
module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"
}
```
<!-- END_TF_DOCS -->