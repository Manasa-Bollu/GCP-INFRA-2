# Architecture

The infrastructure consists of two main environments: `dev` and `qa`, each in separate GCP projects.

## Components
- **VPC & Serverless VPC Access:** Custom network allowing Cloud Run to securely connect to Cloud SQL and Memorystore via private IP.
- **Cloud Run:** Hosts the Frontend and Backend applications separately. Scales from 0 to 3.
- **External HTTP(S) Load Balancer:** Routes traffic. Paths starting with `/api` go to the backend, the rest to the frontend.
- **Cloud SQL (PostgreSQL):** Private IP only DB. 
- **Memorystore (Redis):** Basic tier cache instance via Private Service Access.
- **Secret Manager:** Stores DB credentials, URLs, and application secrets securely.
- **Artifact Registry:** Docker repository.
- **IAM:** Strictly least privileged Service Accounts for GitHub Actions (via Workload Identity Federation), Backend, and Frontend.
