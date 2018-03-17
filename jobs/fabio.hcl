job "fabio" {
  datacenters = ["dc1"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
    constraint {
      distinct_hosts = true
    }

    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        port_map {
          http = 9999
          ui = 9998
        }
      }

      resources {
        cpu = 100
        memory = 64
        network {
          mbits = 1

          port "http" {
            static = 80
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
