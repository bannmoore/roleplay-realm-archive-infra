resource "digitalocean_project" "project" {
  name        = "roleplay-realm-archive"
  description = "Roleplay Realm Archive"
  environment = "development"
  purpose     = "Web Application"
  resources   = [digitalocean_app.web.urn]
}

resource "digitalocean_container_registry" "app_registry" {
  name                   = "bam"
  subscription_tier_slug = "starter"
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
        value = "$${starter-db.DATABASE_URL}"
      }
    }

    database {
      name       = "starter-db"
      engine     = "PG"
      production = false
    }
  }
}
