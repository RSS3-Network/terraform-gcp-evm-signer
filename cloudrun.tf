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

    }

  }
}

resource "google_cloud_run_service_iam_binding" "invoke" {
  location = google_cloud_run_v2_service.signer.location
  service  = google_cloud_run_v2_service.signer.name
  role     = "roles/run.invoker"
  members  = var.cloud_run_invoke_members
}
