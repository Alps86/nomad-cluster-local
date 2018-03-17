job "php" {
  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "5s"
    max_parallel = 10
  }

  group "web" {
    count = 10
    task "web" {
      service {
        name = "web"
        port = "http"
        tags = [
          "urlprefix-/php"
        ]
        check {
          type     = "http"
          path     = "/php"
          interval = "10s"
          timeout  = "2s"
        }
      }
      driver = "docker"
      config {
        port_map {
          http = 80
        }
        image = "661188363101.dkr.ecr.eu-central-1.amazonaws.com/fpm:latest"
        auth {
          username = "MYMAGICUSER"
          password = "MYMAGICPASSWORD"
        }
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
