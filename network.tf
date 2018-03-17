resource "docker_network" "nomad-cluster" {
  name = "nomad-cluster"
  check_duplicate = true
  lifecycle {
    ignore_changes = []
  }
  ipam_config {
    subnet = "172.100.0.0/16"
    gateway = "172.100.0.1"
  }
}