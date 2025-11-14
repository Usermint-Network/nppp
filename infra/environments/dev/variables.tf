variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "media_bucket_name" {
  type        = string
  description = "Media bucket name"
}

variable "api_image" {
  type        = string
  description = "Container image for the Usermint API"
