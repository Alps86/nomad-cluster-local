```bash
docker volume create --name nomad-workspace --opt type=none --opt device=$PWD/code --opt o=bind
```

```bash
terraform apply
```