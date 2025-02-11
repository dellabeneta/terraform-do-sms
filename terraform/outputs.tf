# Output para pegar informações do banco
output "db_connection" {
  value = {
    host     = digitalocean_database_cluster.db.host
    port     = digitalocean_database_cluster.db.port
    database = digitalocean_database_cluster.db.database
    user     = digitalocean_database_cluster.db.user
    password = digitalocean_database_cluster.db.password
  }
  sensitive = true
}

# Output para pegar informações da função
output "function_url" {
  value = digitalocean_function.send_sms.invoke_endpoint
}

# Output para pegar informações do frontend
output "frontend_url" {
  value = digitalocean_app_service.frontend.http_url
}

# Output para pegar informações do backend
output "backend_url" {
  value = digitalocean_app_service.backend.http_url
}

# Output para pegar informações do Twilio
output "twilio" {
  value = {
    account_sid  = var.twilio_account_sid
    auth_token   = var.twilio_auth_token
    phone_number = var.twilio_phone_number
  }
  sensitive = true
}
