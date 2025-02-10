# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key
data "digitalocean_ssh_key" "rra_admin" {
  name = "ssh_admin"
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume
resource "digitalocean_volume" "rra_jump_server_data" {
  name        = "rra-jump-server-volume"
  region      = var.do_region
  size        = 10
  description = "Jump server for database management"
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet
resource "digitalocean_droplet" "rra_jump_server" {
  image    = "ubuntu-24-10-x64"
  name     = "rra-jump-server"
  region   = var.do_region
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.rra_admin.fingerprint]
  vpc_uuid = digitalocean_vpc.rra_vpc.id
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment
resource "digitalocean_volume_attachment" "rra_jump_volume_attachment" {
  droplet_id = digitalocean_droplet.rra_jump_server.id
  volume_id  = digitalocean_volume.rra_jump_server_data.id
}
