variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "media_bucket_name" {
  type        = string
  description = "Media bucket name for dev"
}

variable "api_image" {
  type        = string
  description = "Container image for the Usermint API"
  # Optional: pin a sensible default to the last known-good image
  default = "us-central1-docker.pkg.dev/usermint-network/usermint/api:1763074929"
}
