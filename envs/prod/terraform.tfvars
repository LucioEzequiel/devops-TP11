environment       = "prod"
backend_image     = "notes-backend:v1.0.0"
frontend_image    = "notes-frontend:v1.0.0"
backend_replicas  = 3
frontend_port     = 8091
network_subnet    = "172.30.0.0/16"
monitoring_subnet = "172.31.0.0/16"
