variable "domain_name" {
  type        = string
<<<<<<< HEAD
  description = "GCP Project ID"
=======
  description = "Domain name for the dev environment"
  default     = "dev-api.usermintnetwork.com"
>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))
}

variable "zone" {
  type        = string
<<<<<<< HEAD
  description = "GCP Region"
}

variable "media_bucket_name" {
  type        = string
  description = "Media bucket name"
}

variable "api_image" {
  type        = string
  description = "Container image for the Usermint API"
  default     = "us-central1-docker.pkg.dev/usermint-network/usermint/api:1763087418"
}

variable "project_id" { type = string }
variable "region"     { type = string }          # e.g. us-central1
variable "media_bucket_name" { type = string }   # you already use this
variable "api_image"  { type = string }          # already in use

# New bits:
variable "domain_name" {
  description = "Your custom domain for the HTTPS LB (e.g. api.example.com). Leave empty to skip cert/proxy."
  type        = string
  default     = ""
}

variable "redis_tier"   { type = string  default = "BASIC" }   # BASIC or STANDARD_HA
variable "redis_size_gb"{ type = number  default = 1 }
variable "vpc_name"     { type = string  default = "default" } # keep default VPC for dev
variable "mig_zone"     { type = string  default = "us-central1-a" }
variable "mig_size"     { type = number  default = 1 }



=======
  description = "Default compute zone for dev worker MIG"
  default     = "us-central1-a"
}

>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))
