output "web_app_service_url" {
  value = kubernetes_service.web_app_service.load_balancer_ingress[0].hostname
}
