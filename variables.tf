variable "environment" {
  description = "Entorno de deployment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser dev, staging o prod."
  }
}

variable "project_name" {
  description = "Prefijo para todos los recursos"
  type        = string
  default     = "devops-portfolio"
}

variable "postgres_image" {
  description = "Imagen de Postgres"
  type        = string
  default     = "postgres:16-alpine"
}

variable "postgres_password" {
  description = "Contrasena de Postgres (se pasa por TF_VAR_postgres_password)"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "notesdb"
}

variable "backend_image" {
  description = "Imagen del backend"
  type        = string
}

variable "backend_port" {
  description = "Puerto del backend"
  type        = number
  default     = 5000
}

variable "backend_replicas" {
  description = "Cantidad de contenedores del backend"
  type        = number
  default     = 1

  validation {
    condition     = var.backend_replicas >= 1 && var.backend_replicas <= 5
    error_message = "Las replicas deben estar entre 1 y 5."
  }
}

variable "frontend_image" {
  description = "Imagen del frontend"
  type        = string
}

variable "frontend_port" {
  description = "Puerto del frontend en el host"
  type        = number
  default     = 8090
}

variable "network_subnet" {
  description = "Subnet de la red de la app"
  type        = string
  default     = "172.28.0.0/16"
}

variable "monitoring_subnet" {
  description = "Subnet de la red de monitoreo"
  type        = string
  default     = "172.29.0.0/16"
}
