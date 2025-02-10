# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/domain
resource "digitalocean_domain" "roleplay_realm_archive" {
  name = "roleplay-realm-archive.com"
}

# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/app
resource "digitalocean_app" "rra_app" {
  spec {
    name   = "roleplay-realm-archive"
    region = var.do_app_region

    alert {
      rule = "DEPLOYMENT_FAILED"
    }

    domain {
      name = digitalocean_domain.roleplay_realm_archive.name
      type = "PRIMARY"
      zone = digitalocean_domain.roleplay_realm_archive.name
    }

    service {
      name               = "web"
      http_port          = 80
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

      env {
        key   = "BASE_URL"
        value = "https://${digitalocean_domain.roleplay_realm_archive.name}"
      }

      env {
        key   = "DISCORD_API_URL"
        value = "https://discord.com/api"
      }

      env {
        key   = "DISCORD_CLIENT_ID"
        value = var.discord_client_id
      }

      env {
        key   = "DISCORD_CLIENT_SECRET"
        value = var.discord_client_secret
      }

      env {
        key   = "DISCORD_STATE"
        value = var.discord_state
      }

      env {
        key   = "DISCORD_BOT_TOKEN"
        value = var.discord_bot_token
      }
    }

    database {
      name         = "rra-postgres"
      cluster_name = digitalocean_database_cluster.rra_postgres.name
      db_name      = "defaultdb"
      db_user      = "doadmin"
      engine       = "PG"
      production   = true
    }
  }
}
