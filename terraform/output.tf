output "database_url" {
  sensitive = true
  value     = digitalocean_database_cluster.rra_postgres.uri
}

output "jump_server_address" {
  value = digitalocean_droplet.rra_jump_server.ipv4_address
}
