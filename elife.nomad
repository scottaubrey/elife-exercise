job "elife" {
  datacenters = ["aubreynet"]

  type = "service"

  group "elife-web" {
    count = 1

    network {
      port "web-alt" {
        to = 80
      }
    }

    ephemeral_disk {
      migrate = true
      size    = 200
      sticky  = true
    }

    service {
      name = "elife"
      port = "web-alt"

      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }

    }

    task "mynginx" {
      driver = "docker"

      config {
        image = "ghcr.io/scottaubrey/mynginx:latest"
        ports = ["web-alt"]
        volumes = [
          "../alloc/data:/usr/share/nginx/html"
        ]

      }

      resources {
        cpu    = 500
        memory = 256
      }
    }

    task "php-updater" {
      driver = "docker"

      config {
        image = "ghcr.io/scottaubrey/php-updater:latest"
        volumes = [
          "../alloc/data:/var/www"
        ]
      }

      resources {
        cpu    = 20
        memory = 64
      }
    }
  }
}
