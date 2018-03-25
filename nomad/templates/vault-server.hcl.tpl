storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

listener "tcp" {
  address     = "$PRIVATE_IP:8200"
  #scheme  = "http"
  tls_disable = 1
}

#telemetry {
#  statsite_address = "$PRIVATE_IP:8125"
#  disable_hostname = true
#}