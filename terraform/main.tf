resource "digitalocean_project" "project" {
  name        = "roleplay-realm-archive"
  description = "Roleplay Realm Archive"
  environment = "development"
  purpose     = "Web Application"
  resources = [
    digitalocean_app.web.urn,
    digitalocean_database_cluster.postgres.urn,
    digitalocean_droplet.postgres_jump_box.urn,
    digitalocean_volume.postgres_jump_data.urn
  ]
}

resource "digitalocean_database_cluster" "postgres" {
  name                 = "postgres"
  engine               = "pg"
  version              = "17"
  size                 = "db-s-1vcpu-1gb"
  region               = "sfo3"
  node_count           = 1
  private_network_uuid = digitalocean_vpc.web.id
}

output "postgres_url" {
  sensitive = true
  value     = digitalocean_database_cluster.postgres.uri
}

resource "digitalocean_database_firewall" "postgres" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.postgres_jump_box.id
  }

  rule {
    type  = "app"
    value = digitalocean_app.web.id
  }
}

data "digitalocean_ssh_key" "ssh_admin" {
  name = "ssh_admin"
}

resource "digitalocean_vpc" "web" {
  name   = "web-network"
  region = "sfo3"
}

resource "digitalocean_volume" "postgres_jump_data" {
  name        = "postgres-jump-data"
  region      = "sfo3"
  size        = 10
  description = "Jump server for database management"
}

resource "digitalocean_droplet" "postgres_jump_box" {
  image    = "ubuntu-24-10-x64"
  name     = "postgres-jump-box"
  region   = "sfo3"
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_admin.fingerprint]
  vpc_uuid = digitalocean_vpc.web.id
}

resource "digitalocean_volume_attachment" "postgres_jump_box_data" {
  droplet_id = digitalocean_droplet.postgres_jump_box.id
  volume_id  = digitalocean_volume.postgres_jump_data.id
}

output "postgres_jump_box_addr" {
  value = digitalocean_droplet.postgres_jump_box.ipv4_address
}

resource "digitalocean_app" "web" {
  spec {
    name   = "roleplay-realm-archive"
    region = "sfo"

    alert {
      rule = "DEPLOYMENT_FAILED"
    }

    service {
      name               = "web"
      http_port          = 3000
      instance_count     = 1
      instance_size_slug = "basic-xxs"

      image {
        registry_type = "DOCR"
        repository    = "roleplay-realm-archive"
        tag           = "latest"
        deploy_on_push {
          enabled = true
        }
      }

      env {
        key   = "DATABASE_URL"
        value = "$${postgres.DATABASE_URL}"
      }
    }

    database {
      name         = "postgres"
      cluster_name = digitalocean_database_cluster.postgres.name
      db_name      = "defaultdb"
      db_user      = "doadmin"
      engine       = "PG"
      production   = true
    }
  }
}
