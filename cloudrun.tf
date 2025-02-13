locals {
  common_envs = {
    SIGNER_TYPE              = "gcpkms"
    SGINER_GCPKMS_PROJECT_ID = var.project

  }
}

resource "google_cloud_run_v2_service" "signer" {
  name     = "${var.name}-signer"
  location = var.location
  ingress  = var.cloud_run_ingress

  template {
    service_account = google_service_account.cloud_run_service_account.email

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
        value = google_kms_key_ring.primary.name
      }

      env {
        name  = "SIGNER_GCPKMS_KEY"
        value = google_kms_crypto_key.primary.name
      }

      env {
        name  = "SIGNER_GCPKMS_VERSION"
        value = data.google_kms_crypto_key_latest_version.primary.version
      }

    }

  }
}
