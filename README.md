```bash
docker volume create --name nomad-workspace --opt type=none --opt device=$PWD/code --opt o=bind
```

```bash
terraform init
terraform apply
```

http://172.100.1.2:3000