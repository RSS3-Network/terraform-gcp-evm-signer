locals {
  common_envs = {
    SIGNER_TYPE              = "gcpkms"
    SIGNER_GCPKMS_PROJECT_ID = var.project
    SIGNER_GCPKMS_LOCATION   = var.location
  }
}

resource "google_cloud_run_v2_service" "signer" {
  name     = "${var.name}-signer"
  location = var.cloud_run_location
  ingress  = var.cloud_run_ingress

  template {
    service_account = google_service_account.cloud_run_service_account[0].email

    containers {
      name  = "signer"
      image = var.cloud_run_image
      ports {
        container_port = var.cloud_run_port
      }
      resources {
        limits = var.cloud_run_resource_limit
      }

      dynamic "env" {
        for_each = local.common_envs
        content {
          name  = env.key
          value = env.value
        }
      }

      env {
        name  = "SIGNER_GCPKMS_KEY_RING"
        value = local.key_ring_name
      }

      env {
        name  = "SIGNER_GCPKMS_KEY"
        value = local.crypto_key_name
      }

      env {
        name  = "SIGNER_GCPKMS_VERSION"
        value = data.google_kms_crypto_key_latest_version.primary.version
      }

      liveness_probe {
        http_get {
          path = "/healthz"
        }
        initial_delay_seconds = 30
        period_seconds        = 15
        timeout_seconds       = 1
        failure_threshold     = 3
      }
    }

  }
}

resource "google_cloud_run_service_iam_binding" "invoke" {
  location = google_cloud_run_v2_service.signer.location
  service  = google_cloud_run_v2_service.signer.name
  role     = "roles/run.invoker"
  members  = var.cloud_run_invoke_members
}
