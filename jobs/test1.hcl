job "test1" {
  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "5s"
    max_parallel = 3
  }

  group "web" {
    count = 3
    task "web" {
      vault {
        policies = ["default"]
      }

      template {
        data = <<EOH
  FOO="{{ key "foo" }}"
  API_KEY="{{with secret "secret/hello"}}{{.Data.value}}{{end}}"
  EOH

        destination = "secrets/file.env"
        env         = true
        change_mode   = "noop"
      }

      service {
        name = "web"
        port = "http"
        tags = [
          "urlprefix-test.nomad:9999/"
        ]
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
      driver = "docker"
      config {
        port_map {
          http = 80
        }
        dns_servers        = ["172.17.0.1"]
        dns_search_domains = ["consul"]
        image = "php:7-apache"
        volumes = [
          "/code/test1:/var/www/html"
        ]
      }

      resources {
        cpu = 100
        memory = 64
        network {
          mbits = 1
          port "http" {}
        }
      }
    }
  }
}
