1. ssh-keygen -t ed25519 -f bastion_key        # new key; never commit the private key
2. cp terraform.tfvars.example terraform.tfvars  # set admin_cidr to your IP/32
3. terraform init && terraform validate && terraform plan
