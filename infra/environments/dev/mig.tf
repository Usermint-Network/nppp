<<<<<<< HEAD
terraform fmt lb.tf            # optional, just formatting
terraform plan \
  -var="project_id=usermint-network" \
  -var="region=us-central1" \
  -var="media_bucket_name=MEDIA_BUCKET_DEV_1" \
  -var="api_image=us-central1-docker.pkg.dev/usermint-network/usermint/api:$TAG"

terraform apply -auto-approve \
  -var="project_id=usermint-network" \
  -var="region=us-central1" \
  -var="media_bucket_name=MEDIA_BUCKET_DEV_1" \
  -var="api_image=us-central1-docker.pkg.dev/usermint-network/usermint/api:$TAG"
=======

# MIG & autoscaler for background workers
# TODO: define instance_template + managed instance group + autoscaler


>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))
