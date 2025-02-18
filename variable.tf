variable "name" {
  type        = string
  description = "The name of the module"
}

variable "project" {
  description = "the project id"
  type        = string
}

variable "location" {
  description = "the location of kms key ring"
  type        = string
}

variable "create_key_ring" {
  type        = bool
  description = "if true, create key ring"
  default     = true
}

variable "key_ring_name" {
  description = "the name of the key ring"
  type        = string
}

variable "create_crypto_key" {
  type        = bool
  description = "if true, create crypto key"
  default     = true
}

variable "crypto_key_name" {
  type        = string
  description = "the name of the crypto key"
}

variable "create_service_account" {
  type        = bool
  description = "if true, create a service account for the cloud run service"
  default     = true
}

variable "service_account_name" {
  type        = string
  description = "The name of the service account that will be created if create_service_account is true. If you wish to use an existing service account, use service_account variable."
  default     = ""
}

variable "cloud_run_location" {
  type        = string
  description = "The location of the Cloud Run service"
}

variable "cloud_run_image" {
  type        = string
  description = "The image to deploy to Cloud Run"
}

variable "cloud_run_port" {
  type        = number
  description = "The port that the container listens on"
  default     = 8000
}

variable "cloud_run_ingress" {
  type        = string
  description = "Provides the ingress settings for this Service. On output, returns the currently observed ingress settings, or INGRESS_TRAFFIC_UNSPECIFIED if no revision is active."
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "cloud_run_resource_limit" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "The resource limits for the Cloud Run service"
  default = {
    cpu    = "1"
    memory = "512Mi"
  }
}

variable "cloud_run_invoke_members" {
  type        = list(string)
  description = "The members that can invoke the Cloud Run service"
  default     = []
}
