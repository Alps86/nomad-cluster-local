datacenter = "dc1"
data_dir   = "/mnt/nomad"
bind_addr = "${server_ip}"

client {
  enabled = true
  network_interface = "eth0"
}
