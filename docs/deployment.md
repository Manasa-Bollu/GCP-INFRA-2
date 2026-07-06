# Deployment Guide

## GitHub Actions setup

The `.github/workflows` deploy the application directly to Cloud Run. They use Workload Identity Federation instead of long-lived keys.

1. Ensure the `github_repository` variable in the Terraform environment matches your actual org/repo (e.g., `billvantis/training-platform`).
2. Update the `.github/workflows/deploy-backend.yml` and `deploy-frontend.yml` to replace the placeholder `env` values (`DEV_PROJECT_ID`, `DEV_WIF_PROVIDER`, etc.) with the outputs from the Terraform apply.
3. Configure GitHub Environments if you require manual approval for `qa`. Go to Settings -> Environments -> Create `qa` and add required reviewers.
