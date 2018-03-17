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
      driver = "exec"
      config {
        command = "fabio-1.3.3-go1.7.1-linux_amd64"
      }

      artifact {
        source = "https://github.com/eBay/fabio/releases/download/v1.3.3/fabio-1.3.3-go1.7.1-linux_amd64"
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
