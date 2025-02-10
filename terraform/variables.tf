variable "discord_client_id" {
  description = "Discord Client ID"
  type        = string
  sensitive   = true
}

variable "discord_client_secret" {
  description = "Discord Client Secret"
  type        = string
  sensitive   = true
}

variable "discord_state" {
  description = "Discord state string"
  type        = string
  sensitive   = true
}

variable "discord_bot_token" {
  description = "Discord Bot Access Token"
  type        = string
  sensitive   = true
}
