variable "do_region" {
  type    = string
  default = "sfo3"
}

# app expects a slightly different slug
variable "do_app_region" {
  type    = string
  default = "sfo"
}

variable "do_token" {
  description = "Digital Ocean token"
  type        = string
  sensitive   = true
}

variable "jump_ssh_public_key_path" {
  description = "Path to the public SSH key used to access the Jump Server"
  type        = string
  default     = "~/.ssh/id_rsa_do.pub"
}

variable "jump_ssh_private_key_path" {
  description = "Path to the private SSH key used to access the Jump Server"
  type        = string
  default     = "~/.ssh/id_rsa_do"
}

variable "jump_server_name" {
  type    = string
  default = "rra-jump-server-data"
}

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
