# Pre-Deployment Variables and Configuration Checklist

Before deploying the infrastructure, you must provide your project-specific details. This document acts as an exhaustive checklist covering **every single variable, environment variable, and hardcoded placeholder** across the entire repository that dictates how the code runs.

## 1. Terraform Environment Variables

You must define these variables. It is recommended to create a `terraform.tfvars` file inside the `bootstrap`, `dev`, and `qa` directories respectively to supply the non-default values.

### Bootstrap Module (`terraform/bootstrap/variables.tf`)
| Variable | Default Value | Required Action |
| :--- | :--- | :--- |
| `project_id` | *(None - Required)* | **Must provide** your GCP Project ID where the remote state bucket will live. |
| `state_bucket_name` | *(None - Required)* | **Must provide** a globally unique name for your Terraform state bucket (e.g., `my-org-tf-state-123`). |
| `region` | `"us-central1"` | Optional. Change if you want the state bucket in a different region. |

### DEV Environment (`terraform/environments/dev/variables.tf`)
| Variable | Default Value | Required Action |
| :--- | :--- | :--- |
| `project_id` | *(None - Required)* | **Must provide** your DEV GCP Project ID. |
| `domain` | `"api.example.com"` | **Must update** to your actual dev domain (e.g., `api.dev.yourcompany.com`). Used for Load Balancer routing and SSL. |
| `github_repository` | `"YOUR_ORG/YOUR_REPO"` | **Must update** to your GitHub repository (e.g., `billvantis/training-platform`). Required for GitHub Actions Workload Identity authentication. |
| `region` | `"us-central1"` | Optional. Change if you want the DEV infrastructure deployed in a different region. |

### QA Environment (`terraform/environments/qa/variables.tf`)
| Variable | Default Value | Required Action |
| :--- | :--- | :--- |
| `project_id` | *(None - Required)* | **Must provide** your QA GCP Project ID. |
| `domain` | `"qa-api.example.com"` | **Must update** to your actual QA domain (e.g., `api.qa.yourcompany.com`). |
| `github_repository` | `"YOUR_ORG/YOUR_REPO"` | **Must update** to your GitHub repository. |
| `region` | `"us-central1"` | Optional. Change if you want the QA infrastructure deployed in a different region. |

---

## 2. Terraform Code Placeholders

Some values dictate the core state mechanism or application secrets and must be updated directly inside the code.

| File Path | Location in Code | Current Value | Required Action |
| :--- | :--- | :--- | :--- |
| `terraform/environments/dev/main.tf` | `backend "gcs" { bucket = ... }` | `"dev-terraform-state-bucket-replace-me"` | **Must update** with the exact bucket name you created during the `bootstrap` phase. |
| `terraform/environments/dev/main.tf` | `module "secret_manager"` | `"placeholder-jwt-secret-replace-me"` | **Must update** with a secure JWT secret for your DEV backend. |
| `terraform/environments/qa/main.tf` | `backend "gcs" { bucket = ... }` | `"qa-terraform-state-bucket-replace-me"` | **Must update** with the exact bucket name you created for QA state. |
| `terraform/environments/qa/main.tf` | `module "secret_manager"` | `"placeholder-jwt-secret-replace-me"` | **Must update** with a secure JWT secret for your QA backend. |
| *Both dev & qa main.tf* | `image_url` | `"us-docker.pkg.dev/cloudrun/container/hello"` | **Do NOT change.** Leave this placeholder. Terraform provisions the infrastructure with this image, and your CI/CD pipelines will seamlessly overwrite it with your real application code. |

---

## 3. GitHub Actions Workflows

The CI/CD pipelines rely on these environment variables to know where to deploy and how to authenticate.

### Deploy Backend Workflow (`.github/workflows/deploy-backend.yml`)
| Environment Variable | Current Value | Required Action |
| :--- | :--- | :--- |
| `DEV_PROJECT_ID` | `'project-dev-replace-me'` | **Must update** to your DEV GCP Project ID. |
| `QA_PROJECT_ID` | `'project-qa-replace-me'` | **Must update** to your QA GCP Project ID. |
| `DEV_WIF_PROVIDER` | `'projects/123456789/...'` | **Must update**. Replace `123456789` with your **Dev Project Number** (found in GCP Console Project Settings). The Terraform output `workload_identity_provider` will give you this exact string. |
| `DEV_SERVICE_ACCOUNT` | `'github-actions-sa@project-dev-replace-me.iam.gserviceaccount.com'` | **Must update**. Replace `project-dev-replace-me` with your DEV Project ID. The Terraform output `github_actions_sa_email` will give you this exact string. |
| `REGION` | `'us-central1'` | Optional. Must match the region you deployed Terraform into. |
| `IMAGE_NAME` | `'backend-service'` | Optional. Change if you want your Docker image named differently. |

### Deploy Frontend Workflow (`.github/workflows/deploy-frontend.yml`)
| Environment Variable | Current Value | Required Action |
| :--- | :--- | :--- |
| `DEV_PROJECT_ID` | `'project-dev-replace-me'` | **Must update** to your DEV GCP Project ID. |
| `DEV_WIF_PROVIDER` | `'projects/123456789/...'` | **Must update** using your **Dev Project Number**. |
| `DEV_SERVICE_ACCOUNT` | `'github-actions-sa@project-dev-replace-me.iam.gserviceaccount.com'` | **Must update** using your DEV Project ID. |
| `REGION` | `'us-central1'` | Optional. Must match the region you deployed Terraform into. |
| `IMAGE_NAME` | `'frontend-service'` | Optional. Change if you want your Docker image named differently. |

*(Note: When you are ready to configure the automated QA deployment step in the workflows, you will need to add equivalent `QA_WIF_PROVIDER` and `QA_SERVICE_ACCOUNT` variables pointing to your QA project).*
