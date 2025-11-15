variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region (e.g., us-central1)"
}

variable "media_bucket_name" {
  type        = string
  description = "GCS bucket for media"
}

variable "api_image" {
  type        = string
  description = "Container image for the Usermint API"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the dev environment"
  default     = "dev-api.usermintnetwork.com"
}

variable "zone" {
  type        = string
  description = "Default compute zone for dev worker MIG"
  default     = "us-central1-a"
}

variable "redis_tier" {
  type        = string
  description = "Redis tier (BASIC or STANDARD_HA)"
  default     = "STANDARD_HA"
}

variable "redis_size_gb" {
  type        = number
  description = "Redis memory size in GB"
  default     = 1
}

variable "vpc_name" {
  type        = string
  description = "VPC name (for future refactor if needed)"
  default     = "usermint-dev-vpc"
}

variable "mig_zone" {
  type        = string
  description = "Zone for future MIG instances"
  default     = "us-central1-a"
}

variable "mig_size" {
  type        = number
  description = "Target size for future MIG"
  default     = 1
}
