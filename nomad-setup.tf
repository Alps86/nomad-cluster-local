module "servers" {
  source = "./nomad"

  namespace = "${var.namespace}-server"
  instances = "${length(var.server_ips)}"
  server_ips = "${var.server_ips}"
  consul_ips = "${var.server_ips}"

  named_volume = "nomad-workspace"

  consul_enabled = true
  consul_type    = "server"
  consul_version = "${var.consul_version}"

  vault_enabled = true
  vault_type    = "server"
  vault_version = "${var.vault_version}"

  nomad_enabled = true
  nomad_type    = "server"
  nomad_version = "${var.nomad_version}"

  hashiui_enabled = false
}

module "clients" {
  source = "./nomad"

  namespace = "${var.namespace}-client"
  instances = "${length(var.client_ips)}"
  server_ips = "${var.client_ips}"
  consul_ips = "${var.server_ips}"

  named_volume = "nomad-workspace"

  consul_enabled = true
  consul_type    = "client"
  consul_version = "${var.consul_version}"

  vault_enabled = false
  vault_type    = "client"
  vault_version = "${var.vault_version}"

  nomad_enabled = true
  nomad_type    = "client"
  nomad_version = "${var.nomad_version}"

  hashiui_enabled = true
  hashiui_version = "${var.hashiui_version}"
}

/**
resource "null_resource" "jobs" {
  connection {
    host = "${element(var.server_ips, count.index)}"
    port = "22"
    user = "root"
    password = "root"
  }

  provisioner "remote-exec" {
    inline = [
      "export NOMAD_ADDR=http://${element(var.server_ips, count.index)}:4646",
      "printenv",
      "nomad server-members",
      "nomad run jobs/fabio.hcl",
      "nomad run jobs/test1.hcl",
      "nomad run jobs/test2.hcl",
    ]
  }
}
*/