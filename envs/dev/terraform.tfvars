environment       = "dev"
backend_image     = "notes-backend:v1.0.0"
frontend_image    = "notes-frontend:v1.0.0"
backend_replicas  = 1
frontend_port     = 8090
network_subnet    = "172.28.0.0/16"
monitoring_subnet = "172.29.0.0/16"
