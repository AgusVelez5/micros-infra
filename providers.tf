provider "kubernetes" {
  host     = google_container_cluster.gcp_kubernetes.endpoint
  client_certificate     = base64decode(google_container_cluster.gcp_kubernetes.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.gcp_kubernetes.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.gcp_kubernetes.master_auth.0.cluster_ca_certificate)
}

provider "google" {
    project     = "socks-294622"
    region      = "southamerica-east1"
}