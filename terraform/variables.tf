variable "do_token" {}

variable "ssh_keys" {
  type = set(string)
  default = [
    "bigrig"
  ]
}

variable "lb_zones" {
  type = map
  default = {
    "nyc1" = 1
  }
}

variable "worker_zones" {
  type = map
  default = {
    "nyc1" = 3
  }
}
