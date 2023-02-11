variable "docker_host" {
  type        = string
  description = "Docker host address"
  default     = "unix:///var/run/docker.sock"
}
