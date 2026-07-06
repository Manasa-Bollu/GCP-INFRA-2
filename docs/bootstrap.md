# Bootstrap Guide

Before applying the main environments (`dev` or `qa`), you must provision the Terraform state bucket.

## Steps
1. Navigate to `terraform/bootstrap`
2. Update `terraform.tfvars` (or pass vars) with your `project_id` and a globally unique `state_bucket_name`.
3. Authenticate to GCP: `gcloud auth application-default login`
4. Run `terraform init`
5. Run `terraform apply`

Once the bucket is created, update the `backend "gcs"` block in `terraform/environments/dev/main.tf` and `terraform/environments/qa/main.tf` with the new bucket name.
