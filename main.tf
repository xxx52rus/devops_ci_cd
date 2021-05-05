# You need to install the GCloud CLI app and authenticate using commands:
#   gcloud auth login 
#   gcloud auth application-default login
# Also you need to create a GCS bucket manually


terraform {
  backend "gcs" {
    bucket  = "epam-15-terraform-backend"
    prefix  = "state.json"
  }
}

provider "google" {
  project = "epam-15"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

resource "google_container_cluster" "epam_15_c1" {
  project  = "epam-15" 
  name     = "c1"
  location = "europe-north1-a"
  min_master_version = "1.18"
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "linux_pool" {
  name               = "linux-pool"
  project            = google_container_cluster.epam_15_c1.project
  cluster            = google_container_cluster.epam_15_c1.name
  location           = google_container_cluster.epam_15_c1.location
  node_count = 3
    

  node_config {
    machine_type = "e2-standard-2"
    image_type   = "COS_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
