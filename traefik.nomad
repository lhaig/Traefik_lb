job "traefik" {
  region      = "[[.job.region]]"
  datacenters = [ [[range $index, $value := .job.datacenters]][[if ne $index 0]],[[end]]"[[$value]]"[[end]] ]
  type        = "[[.job.type]]"

  group "traefik" {
  
    task "traefik" {
      driver = "docker"

      config {
        image        = "[[.config.image]]"
        network_mode = "[[.config.network_mode]]"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":8080"
    [entryPoints.traefik]
    address = ":8081"

[ping]
  entryPoint = "traefik"

[api]
    dashboard = true
    insecure = true
    debug = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
  prefix = "traefik"
  exposedByDefault = false
  [providers.consulCatalog.endpoint]
    address = "[[.consul.adress]]"
     scheme = "[[.consul.scheme]]"


EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = [[.resources.cpu]]
        memory = [[.resources.memory]]

        network {
          mbits = [[.resources.network.mbits]]

          port "http" {
            static = "[[.resources.port.http]]"
          }

          port "api" {
            static = "[[.resources.port.api]]"
          }
        }
      }

      service {
        name = "[[.service.name]]"
        tags = [ [[range $index, $value := .service.tags]][[if ne $index 0]],[[end]]"[[$value]]"[[end]] ]
        check {
          name     = "alive"
          type     = "tcp"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}