## Use this only when in WSL

#!/bin/bash

terraform fmt
terraform validate
terraform plan --var-file='terraform.tfvars'
