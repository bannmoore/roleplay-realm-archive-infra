resource "digitalocean_project" "project" {
  name        = "roleplay-realm-archive"
  description = "Roleplay Realm Archive"
  environment = "development"
  purpose     = "Web Application"
}

resource "digitalocean_container_registry" "app_registry" {
  name                   = "bam"
  subscription_tier_slug = "starter"
}
