variable "docker_host" {
  type        = string
  description = "Docker host address"
  default     = "unix:///var/run/docker.sock"
}

variable "tcp_ports" {
  type        = list(number)
  description = "List of TCP ports"
  default     = [8443, 8080, 8843, 8880, 6789]
}

variable "udp_ports" {
  type        = list(number)
  description = "List of UDP ports"
  default     = [3478, 10001, 1900, 5514]
}
