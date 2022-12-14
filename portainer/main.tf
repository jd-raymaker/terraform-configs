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

resource "docker_image" "portainer" {
  name         = "portainer/portainer-ce:alpine"
  keep_locally = false
}

resource "docker_container" "portainer" {
  image   = docker_image.portainer.latest
  name    = "portainer"
  restart = "always"
  ports {
    internal = 8000
    external = 8000
  }
  ports {
    internal = 9443
    external = 9443
  }
  ports {
    internal = 9000
    external = 9000
  }
  mounts {
    type   = "bind"
    source = "/var/run/docker.sock"
    target = "/var/run/docker.sock"
  }
  volumes {
    volume_name    = "portainer_data"
    container_path = "/data"
  }
  mounts {
    type   = "bind"
    source = var.local_certs_path
    target = "/certs"
  }
  command = ["--sslcert", "/certs/portainer.crt", "--sslkey", "/certs/portainer.key"]
}

resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}
