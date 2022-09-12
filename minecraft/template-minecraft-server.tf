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

resource "docker_image" "minecraft-server" {
  name         = "itzg/minecraft-server"
  keep_locally = false
}

resource "docker_container" "mc" {
  image   = docker_image.minecraft-server.latest
  name    = "mc"
  restart = "unless-stopped"
  tty = true
  stdin_open = true
  env = [ "EULA=TRUE" ]
  ports {
    internal = 25565
    external = 25565
  }
  volumes {
    volume_name    = "mc_data"
    container_path = "/data"
  }
}

resource "docker_volume" "mc_data" {
  name = "mc_data"
}
