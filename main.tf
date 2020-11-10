resource "google_container_cluster" "gcp_kubernetes" {
    name               = var.cluster_name
    location           = "southamerica-east1-a"
    initial_node_count = var.gcp_cluster_count

    master_auth {
        username = var.linux_admin_username
        password = var.linux_admin_password

        client_certificate_config {
          issue_client_certificate = false
      }
    }
    
    node_config {
        oauth_scopes = [
          "https://www.googleapis.com/auth/compute",
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
        ]

        labels = {
            stage = "dev-cluster"
        }

        tags = ["dev"]
    }
}

resource "null_resource" "get_credentials" {

  depends_on = [google_container_cluster.gcp_kubernetes] 

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.gcp_kubernetes.name} --zone=${google_container_cluster.gcp_kubernetes.location} --project=socks-294622"
  }
}

resource "kubernetes_namespace" "shop_namespace" {

  depends_on = [null_resource.get_credentials]

  metadata {
    name = "sock-shop"
  }
}

resource "null_resource" "deploy_app" {

  depends_on = [null_resource.get_credentials, kubernetes_namespace.shop_namespace]

  provisioner "local-exec" {
    command = "kubectl apply -f deploy.yml"
  }

}  


