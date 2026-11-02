output "app_network_name" {
  description = "Nombre de la red de la app"
  value       = docker_network.app_network.name
}

output "monitoring_network_name" {
  description = "Nombre de la red de monitoreo"
  value       = docker_network.monitoring_network.name
}
