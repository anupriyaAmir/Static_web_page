provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "demo"
  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "web-app-node-group"
  subnet_ids      = module.vpc.private_subnets
  instance_types  = ["t3.micro"]
  desired_size    = 2
}

resource "kubernetes_deployment" "web_app" {
  metadata {
    name = "web-app-deployment"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-app"
        }
      }

      spec {
        container {
          name  = "web-app"
          image = "anupriya2616/web-app"
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web_app_service" {
  metadata {
    name = "web-app-service"
  }

  spec {
    selector = {
      app = "web-app"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
