terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
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
  image   = docker_image.unifi.image_id
  name    = "unifi-controller"
  restart = "unless-stopped"
  env     = ["MEM_LIMIT=1024", "MEM_STARTUP=1024"]

  volumes {
    volume_name    = "unifi_config"
    container_path = "/config"
  }

  dynamic "ports" {
    for_each = var.tcp_ports
    content {
      internal = ports.value
      external = ports.value
      protocol = "tcp"
    }
  }

  dynamic "ports" {
    for_each = var.udp_ports
    content {
      internal = ports.value
      external = ports.value
      protocol = "udp"
    }
  }
}

resource "docker_volume" "unifi_config" {
  name = "unifi_config"
}
