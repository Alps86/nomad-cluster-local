# Enable the server
data_dir   = "/mnt/nomad"
bind_addr = "${server_ip}"

server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = ${instances}
}

vault {
    enabled     = true
    #ca_path     = "/etc/certs/ca"
    #cert_file   = "/var/certs/vault.crt"
    #key_file    = "/var/certs/vault.key"

    # Address to communicate with Vault. The below is the default address if
    # unspecified.
    address     = "http://vault.service.consul:8200"

    # Embedding the token in the configuration is discouraged. Instead users
    # should set the VAULT_TOKEN environment variable when starting the Nomad
    # agent
    #token       = "debecfdc-9ed7-ea22-c6ee-948f22cdd474"

    # Setting the create_from_role option causes Nomad to create tokens for tasks
    # via the provided role. This allows the role to manage what policies are
    # allowed and disallowed for use by tasks.
    create_from_role = "nomad-cluster"
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
