# Infrastructure Repository

This repository contains the Infrastructure-as-Code (IaC) required to provision the multi-tier application environment on Google Cloud Platform using Terraform.

## Project Structure
- `terraform/bootstrap`: Provisions the remote state bucket.
- `terraform/environments`: The root configurations for `dev` and `qa`.
- `terraform/modules`: Reusable Terraform modules.
- `.github/workflows`: CI/CD pipelines for Backend and Frontend Cloud Run deployment.
- `docs/`: Comprehensive guides.

## Quick Start
1. Read `docs/bootstrap.md` to initialize the state bucket.
2. Read `docs/deployment.md` for applying infrastructure and CI/CD setup.
