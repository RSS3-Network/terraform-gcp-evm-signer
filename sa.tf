locals {
  service_account_default_name = "tf-${substr(var.name, 0, min(15, length(var.name)))}-signer"
}

resource "google_service_account" "cloud_run_service_account" {
  count        = var.create_service_account ? 1 : 0
  project      = var.project
  account_id   = var.service_account_name == "" ? local.service_account_default_name : var.service_account_name
  display_name = "Terraform-managed service account for Cloud Run ${var.name} signer"
}
