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
      service {
        name = "web"
        port = "http"
        tags = [
          "urlprefix-test.localhost:9999/"
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
