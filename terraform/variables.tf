variable "do_token" {
  description = "Token de API da DigitalOcean"
  sensitive   = true
}

# Variáveis do Twilio
variable "twilio_account_sid" {
  description = "SID da conta do Twilio"
  sensitive   = true
}

variable "twilio_auth_token" {
  description = "Token de autenticação do Twilio"
  sensitive   = true
}

variable "twilio_phone_number" {
  description = "Número de telefone do Twilio"
}

