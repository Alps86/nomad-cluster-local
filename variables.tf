variable "namespace" {
  description = <<EOH
The namespace to create the virtual training lab. This should describe the
training and must be unique to all current trainings. IAM users, workstations,
and resources will be scoped under this namespace.

It is best if you add this to your .tfvars file so you do not need to type
it manually with each run
EOH
}

variable "server_ips" {
  type = "list"
  default = [
    "172.100.0.2",
    "172.100.0.3",
    "172.100.0.4"
  ]
}

variable "client_ips" {
  type = "list"
  default = [
    "172.100.1.2",
    "172.100.1.3",
    "172.100.1.4"
  ]
}

variable "consul_version" {
  description = "Consul version to install"
}

variable "nomad_version" {
  description = "Nomad version to install"
}

variable "hashiui_version" {
  description = "Hashi-ui version to install"
}

variable "nomad_servers" {
  description = "The number of nomad servers."
}

variable "nomad_agents" {
  description = "The number of nomad agents"
}

variable "public_key_path" {
  description = "The absolute path on disk to the SSH public key."
  default     = "~/.ssh/id_rsa.pub"
}
