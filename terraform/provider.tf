# Este arquivo é usado para configurar o provedor para a API do DigitalOcean.
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.48.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}