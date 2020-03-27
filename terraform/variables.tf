variable "do_token" {}

variable "ssh_keys" {
  type = set(string)
  default = [
    "bigrig",
    "docker host"
  ]
}

variable "lb_zones" {
  type = map
  default = {
    "nyc1" = 2
  }
}

variable "worker_zones" {
  type = map
  default = {
    "nyc1" = 3
  }
}
