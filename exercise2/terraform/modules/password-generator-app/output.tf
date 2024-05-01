output "url" {
  value = data.kubernetes_service.load_balancer.load_balancer_ip 
}