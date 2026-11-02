resource "docker_container" "postgres" {
  name    = "${var.project_name}-postgres-${var.environment}"
  image   = var.postgres_image
  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=${var.postgres_password}",
  ]

  volumes {
    volume_name    = var.postgres_volume_name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name    = var.app_network_name
    aliases = ["postgres"]
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U postgres"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "20s"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "environment"
    value = var.environment
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}

resource "docker_container" "backend" {
  count      = var.backend_replicas
  name       = "${var.project_name}-backend-${var.environment}-${count.index}"
  image      = var.backend_image
  restart    = "unless-stopped"
  depends_on = [docker_container.postgres]

  env = [
    "DB_HOST=postgres",
    "DB_PORT=5432",
    "DB_NAME=${var.postgres_db}",
    "DB_USER=postgres",
    "DB_PASSWORD=${var.postgres_password}",
    "APP_ENV=${var.environment}",
    "PORT=${var.backend_port}",
  ]

  networks_advanced {
    name    = var.app_network_name
    aliases = ["backend", "backend-${count.index}"]
  }

  healthcheck {
    test         = ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:${var.backend_port}/health')"]
    interval     = "15s"
    timeout      = "5s"
    retries      = 3
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "environment"
    value = var.environment
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
  labels {
    label = "replica"
    value = tostring(count.index)
  }
}

resource "docker_container" "frontend" {
  name       = "${var.project_name}-frontend-${var.environment}"
  image      = var.frontend_image
  restart    = "unless-stopped"
  depends_on = [docker_container.backend]

  ports {
    internal = 80
    external = var.frontend_port
  }

  networks_advanced {
    name    = var.app_network_name
    aliases = ["frontend"]
  }

  labels {
    label = "project"
    value = var.project_name
  }
  labels {
    label = "environment"
    value = var.environment
  }
  labels {
    label = "managed-by"
    value = "terraform"
  }
}
