resource "null_resource" "node" {
  #depends_on = ["docker_network.nomad-cluster"]

  count = "${length(var.server_ips)}"

  provisioner "local-exec" {
    command = "echo server: ${var.namespace}-${count.index}"
  }

  provisioner "local-exec" {
    command = "docker rm -f ${var.namespace}-${count.index} || true"
  }

  provisioner "local-exec" {
    command = "docker run -d -v ${var.named_volume}:/code --privileged --name ${var.namespace}-${count.index} --ip ${element(var.server_ips, count.index)} --net nomad-cluster --security-opt seccomp=unconfined --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -t localhost:5000/nomad-base:latest"
  }

  connection {
    host = "${element(var.server_ips, count.index)}"
    port = "22"
    user = "root"
    password = "root"
  }

  provisioner "file" {
    source      = "${path.root}/jobs"
    destination = "/root"
  }

  provisioner "remote-exec" {
    inline = [
      "${element(data.template_file.startup.*.rendered, count.index)}"
    ]
  }
}

# Create the user-data
data "template_file" "startup" {
  count = "${length(var.server_ips)}"
  template = "${file("${path.module}/templates/startup.sh.tpl")}"

  vars {
    consul_enabled = "${var.consul_enabled}"
    consul_version = "${var.consul_version}"
    consul_type    = "${var.consul_type}"

    consul_config  = "${element(data.template_file.config_consul.*.rendered, count.index)}"

    nomad_enabled = "${var.nomad_enabled}"
    nomad_version = "${var.nomad_version}"
    nomad_type    = "${var.nomad_type}"
    nomad_config  = "${element(data.template_file.config_nomad.*.rendered, count.index)}"

    hashiui_enabled = "${var.hashiui_enabled}"
    hashiui_version = "${var.hashiui_version}"
  }
}

data "template_file" "config_nomad" {
  count = "${length(var.server_ips)}"
  template = "${file("${path.module}/templates/nomad-${var.nomad_type}.hcl.tpl")}"

  vars {
    instances = "${length(var.server_ips)}"
    server_ip = "${element(var.server_ips, count.index)}"
  }
}

data "template_file" "config_consul" {
  count = "${length(var.server_ips)}"
  template = "${file("${path.module}/templates/consul-${var.consul_type}.json.tpl")}"

  vars {
    instances = "${length(var.server_ips)}"
    server_ip = "${element(var.server_ips, count.index)}"
    retry_join = "${join("\",\"", var.consul_ips)}"
  }
}