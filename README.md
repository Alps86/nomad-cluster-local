```bash
docker volume create --name nomad-workspace --opt type=none --opt device=$PWD/code --opt o=bind
```

```bash
terraform init
terraform apply
```

* http://172.100.1.2:3000
* http://172.100.1.2:9998

```bash
vault init -key-shares=1 -key-threshold=1
```

# Download the policy and token role
```bash
curl https://nomadproject.io/data/vault/nomad-server-policy.hcl -O -s -L 
curl https://nomadproject.io/data/vault/nomad-cluster-role.json -O -s -L
```
# Vault Test
* Unseal Key 1: xxxxxxxxxxxxxxxx
* Initial Root Token: yyyyyyyyyyyyyyyyyyyyyy

```bash
vault operator unseal xxxxxxxxxxxxxxxx
vault login yyyyyyyyyyyyyyyyyyyyyy
```

# Write the policy to Vault
```bash
vault policy write nomad-server nomad-server-policy.hcl
```

# Create the token role with Vault
```bash
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json
vault token-create -policy nomad-server -period 72h -orphan -id=d2756bbc-28b0-e3f4-cbe5-9ee8c7c7e795
# on nomad server
echo "  Environment=VAULT_TOKEN=d2756bbc-28b0-e3f4-cbe5-9ee8c7c7e795" >> /etc/systemd/system/nomad.service && systemctl daemon-reload && systemctl start nomad && systemctl status nomad 
```

# Cronjob for
```bash
vault token renew d2756bbc-28b0-e3f4-cbe5-9ee8c7c7e795
```
