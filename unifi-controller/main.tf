terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

resource "docker_image" "unifi" {
  name         = "lscr.io/linuxserver/unifi-controller:latest"
  keep_locally = false
}

resource "docker_container" "unifi_container" {
  image   = docker_image.unifi.latest
  name    = "unifi-controller"
  restart = "unless-stopped"
  env     = ["MEM_LIMIT=1024", "MEM_STARTUP=1024"]
  volumes {
    volume_name    = "unifi_config"
    container_path = "/config"
  }
  ports {
    internal = 8443
    external = 8443
  }
  ports {
    internal = 3478
    external = 3478
    protocol = "udp"
  }
  ports {
    internal = 10001
    external = 10001
    protocol = "udp"
  }
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 1900
    external = 1900
    protocol = "udp"
  }
  ports {
    internal = 8843
    external = 8843
  }
  ports {
    internal = 8880
    external = 8880
  }
  ports {
    internal = 6789
    external = 6789
  }
  ports {
    internal = 5514
    external = 5514
    protocol = "udp"
  }
}

resource "docker_volume" "unifi_config" {
  name = "unifi_config"
}
