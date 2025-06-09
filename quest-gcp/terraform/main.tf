terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "quest_app" {
  name     = "quest-app"
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
        env {
          name  = "SECRET_WORD"
          value = var.secret_word
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  location = google_cloud_run_service.quest_app.location
  project  = var.project_id
  service  = google_cloud_run_service.quest_app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "url" {
  value = google_cloud_run_service.quest_app.status[0].url
}

