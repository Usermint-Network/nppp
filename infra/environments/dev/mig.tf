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
