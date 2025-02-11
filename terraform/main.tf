
# Criar cluster PostgreSQL
resource "digitalocean_database_cluster" "db" {
  name       = "cadastro-db"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1
}


# App Platform (Frontend + Backend)
resource "digitalocean_app" "cadastro_app" {
  spec {
    name   = "cadastro-app"
    region = "nyc1"

    # Frontend (site estático)
    static_site {
      name       = "frontend"
      source_dir = "/"
      output_dir = "/frontend/public"
      github {
        repo           = "dellabeneta/terraform-do-sms"
        branch         = "main"
        deploy_on_push = true
      }
    }

    # Backend (Flask)
    service {
      name = "backend"
      github {
        repo           = "dellabeneta/terraform-do-sms"
        branch         = "main"
        deploy_on_push = true
      }
      source_dir         = "/backend"
      environment_slug   = "python"
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      http_port          = 8000

      # Variáveis de ambiente
      env {
        key   = "DB_NAME"
        value = digitalocean_database_cluster.db.database
      }
      env {
        key   = "DB_USER"
        value = digitalocean_database_cluster.db.user
      }
      env {
        key   = "DB_PASSWORD"
        value = digitalocean_database_cluster.db.password
      }
      env {
        key   = "DB_HOST"
        value = digitalocean_database_cluster.db.host
      }
      env {
        key   = "DB_PORT"
        value = digitalocean_database_cluster.db.port
      }
      env {
        key   = "FUNCTION_URL"
        value = digitalocean_function.send_sms.invoke_endpoint
      }
    }
  }
}

# Function para SMS
resource "digitalocean_function" "send_sms" {
  name    = "send-sms"
  runtime = "nodejs18"
  code {
    path    = "functions/send-sms"
    runtime = "nodejs18"
  }
  environment_variables = {
    TWILIO_ACCOUNT_SID  = var.twilio_account_sid
    TWILIO_AUTH_TOKEN   = var.twilio_auth_token
    TWILIO_PHONE_NUMBER = var.twilio_phone_number
  }
}

# Trigger HTTP para a Function
resource "digitalocean_function_trigger" "sms_trigger" {
  function_id = digitalocean_function.send_sms.id
  name        = "http-trigger"
  type        = "http"
}