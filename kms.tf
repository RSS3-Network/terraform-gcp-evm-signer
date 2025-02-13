locals {
  key_ring_default_name   = "tf-${substr(var.name, 0, min(15, length(var.name)))}-key-ring"
  crypto_key_default_name = "tf-${substr(var.name, 0, min(15, length(var.name)))}-crypto-key"

  key_ring_name   = var.key_ring_name == "" ? local.key_ring_default_name : var.key_ring_name
  crypto_key_name = var.crypto_key_name == "" ? local.crypto_key_default_name : var.crypto_key_name
}

resource "google_kms_key_ring" "primary" {
  # create if var.key_ring is empty
  count    = var.create_key_ring ? 1 : 0
  name     = local.key_ring_name
  location = var.location
  project  = var.project
}

resource "google_kms_crypto_key" "primary" {
  count    = var.create_crypto_key ? 1 : 0
  name     = local.crypto_key_name
  key_ring = local.key_ring_name
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm        = "EC_SIGN_SECP256K1_SHA256"
    protection_level = "HSM"
  }
}

resource "google_kms_crypto_key_iam_binding" "primary" {
  crypto_key_id = google_kms_crypto_key.primary.id
  role          = "roles/cloudkms.signerVerifier"
  members       = ["serviceAccount:${google_service_account.cloud_run_service_account.email}"]
}

data "google_kms_crypto_key_latest_version" "primary" {
  crypto_key = google_kms_crypto_key.primary.id
}
