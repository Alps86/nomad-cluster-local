datacenter = "dc1"
data_dir   = "/mnt/nomad"
bind_addr = "${server_ip}"

client {
  enabled = true
  network_interface = "eth0"
  options {
    "docker.cleanup.image" = "false"
  }
}

vault {
  enabled     = true
  address     = "http://vault.service.consul:8200"
  #ca_path     = "/etc/certs/ca"
  #cert_file   = "/var/certs/vault.crt"
  #key_file    = "/var/certs/vault.key"
}
