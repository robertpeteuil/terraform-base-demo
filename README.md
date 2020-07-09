# Base Terraform Workflow

## Adding dynamic data

External script to get current IP before security group

``` ruby
# FIND EXISTING PUBLIC IP
data "external" "get_local_public_ip" {
  program = ["sh", "scripts/get_local_pub_ip.sh"]
}
```

## Reference dynamic data

Reference to script variable `ip` - line 58

``` ruby
cidr_blocks = [data.external.get_local_public_ip.result.ip]
```
