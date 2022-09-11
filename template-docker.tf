terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  host = "ssh://username@1.2.3.4"
}

resource "docker_image" "foobar" {
  name         = "foobar:latest"
  keep_locally = false
}

resource "docker_container" "foobar" {
  image   = docker_image.foobar.latest
  name    = "foobar"
  restart = "always"
  ports {
    internal = 8080
    external = 8080
  }
  mounts {
    type   = "bind"
    source = "/path/on/host"
    target = "/path/in/container"
  }
  volumes {
    volume_name    = "foobar_data"
    container_path = "/data"
  }
  command = ["--sslcert", "/certs/portainer.crt", "--sslkey", "/certs/portainer.key"]
}

resource "docker_volume" "foobar_data" {
  name = "foobar_data"
}
