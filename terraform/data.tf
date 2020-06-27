data "digitalocean_ssh_key" "ssh_keys" {
  for_each = var.ssh_keys
  name = each.value
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "template_file" "ansible_nodes_conf" {
  template = "${file("../templates/ansible_nodes.conf")}"
  depends_on = [
    digitalocean_droplet.lb_nodes,
    digitalocean_droplet.worker_nodes
  ]
  vars = {
    lb_nodes  = "${jsonencode(digitalocean_droplet.lb_nodes)}",
    worker_nodes  = "${jsonencode(digitalocean_droplet.worker_nodes)}"
  }
}

data "template_file" "nginx_default_conf" {
  template = "${file("../templates/nginx_default.conf")}"
  depends_on = [
    data.http.myip
  ]
  vars = {
    my_ip = "${chomp(data.http.myip.body)}"
  }
}

#data "template_file" "nginx_worker_conf" {
#  template = "${file("../templates/nginx_worker.conf")}"
#  depends_on = [
#    digitalocean_droplet.lb_nodes,
#  ]
#  vars = {
#    lb_nodes  = "${jsonencode(digitalocean_droplet.lb_nodes)}"
#  }
#}

data "template_file" "nginx_lb_conf" {
  template = "${file("../templates/nginx_lb.conf")}"
  depends_on = [
    digitalocean_droplet.worker_nodes
  ]
  vars = {
    worker_nodes  = "${jsonencode(digitalocean_droplet.worker_nodes)}"
  }
}

data "template_file" "nginx_zone_sync_conf" {
  template = "${file("../templates/nginx_zone_sync.conf")}"
  depends_on = [
    digitalocean_droplet.lb_nodes
  ]
  vars = {
    lb_nodes  = "${jsonencode(digitalocean_droplet.lb_nodes)}"
  }
}