terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
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

resource "docker_container" "minecraft" {
  image   = docker_image.minecraft-server.latest
  name    = "minecraft"
  restart = "unless-stopped"
  tty = true
  stdin_open = true
  env = [ "EULA=TRUE" ]
  ports {
    internal = 25565
    external = 25565
  }
  volumes {
    volume_name    = "minecraft_data"
    container_path = "/data"
  }
}

resource "docker_volume" "minecraft_data" {
  name = "minecraft_data"
}
