variable "server_ips" {
  type = "list"
}

variable "consul_ips" {
  type = "list"
}

variable "namespace" {}

variable "instances" {
  description = "The number of nomad servers."
}

variable "named_volume" {
  description = "Volume for the development"
}

# Consul configuration
variable "consul_enabled" {
  description = "Should consul be installed onto the instance?"
}

variable "consul_type" {
  description = "Is the consul instance a server or client"
}

variable "consul_version" {
  description = "Version number for consul"
}

# Vault configuration
variable "vault_enabled" {
  description = "Should vault be installed onto the instance?"
}

variable "vault_type" {
  description = "Is the vault instance a server or client"
}

variable "vault_version" {
  description = "Version number for vault"
}

# Nomad configuration
variable "nomad_enabled" {
  description = "Is nomad enabled on this instance"
}

variable "nomad_type" {
  description = "Is nomad a server or an agent"
}

variable "nomad_version" {
  description = "Version number for nomad"
}

variable "nomad_consul_uri" {
  description = "Location of consul server for bootstrapping"
  default     = "http://localhost:8500"
}

# HashiUI configuration
variable "hashiui_enabled" {
  description = "Is HashiUI enabled on this instance"
}

variable "hashiui_version" {
  description = "Version number for hashi-ui"
  default     = "0.3.6"
}
