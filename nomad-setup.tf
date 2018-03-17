module "servers" {
  source = "./nomad"

  namespace = "${var.namespace}-server"
  instances = "${var.nomad_servers}"
  server_ips = "${var.server_ips}"
  consul_ips = "${var.server_ips}"

  named_volume = "nomad-workspace"

  consul_enabled        = true
  consul_type           = "server"
  consul_version        = "${var.consul_version}"

  nomad_enabled = true
  nomad_type    = "server"
  nomad_version = "${var.nomad_version}"

  hashiui_enabled = false
}

module "clients" {
  source = "./nomad"

  namespace = "${var.namespace}-client"
  instances = "${var.nomad_agents}"
  server_ips = "${var.client_ips}"
  consul_ips = "${var.server_ips}"

  named_volume = "nomad-workspace"

  consul_enabled        = true
  consul_type           = "client"
  consul_version        = "${var.consul_version}"

  nomad_enabled = true
  nomad_type    = "client"
  nomad_version = "${var.nomad_version}"

  hashiui_enabled = true
  hashiui_version = "${var.hashiui_version}"
}
