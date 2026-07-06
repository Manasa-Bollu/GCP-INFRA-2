terraform {
  required_version = ">= 1.7.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "gcs" {
    bucket = "qa-terraform-state-bucket-replace-me"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_services" {
  source     = "../../modules/project-services"
  project_id = var.project_id
}

module "vpc" {
  source       = "../../modules/vpc"
  project_id   = var.project_id
  region       = var.region
  network_name = "qa-vpc"
  subnet_name  = "qa-subnet"
  subnet_cidr  = "10.0.0.0/20"

  depends_on = [module.project_services]
}

module "vpc_connector" {
  source         = "../../modules/vpc-connector"
  project_id     = var.project_id
  region         = var.region
  network_name   = module.vpc.network_name
  connector_name = "qa-vpc-conn"
  subnet_cidr    = "10.1.0.0/28"

  depends_on = [module.project_services]
}

module "service_accounts" {
  source           = "../../modules/service-account"
  project_id       = var.project_id
  service_accounts = ["backend-sa", "frontend-sa", "github-actions-sa"]

  depends_on = [module.project_services]
}

module "iam" {
  source            = "../../modules/iam"
  project_id        = var.project_id
  backend_sa_email  = module.service_accounts.emails["backend-sa"]
  frontend_sa_email = module.service_accounts.emails["frontend-sa"]
  github_sa_email   = module.service_accounts.emails["github-actions-sa"]
  github_sa_id      = module.service_accounts.ids["github-actions-sa"]
  setup_github_wif  = true
  github_repository = var.github_repository

  depends_on = [module.project_services]
}

module "cloud_sql" {
  source                    = "../../modules/cloud-sql"
  project_id                = var.project_id
  region                    = var.region
  vpc_network_id            = module.vpc.network_id
  db_instance_name          = "qa-db-instance"
  db_name                   = "app_db"
  db_user                   = "app_user"
  deletion_protection       = true # True for QA/Prod
  private_vpc_connection_id = module.vpc.private_vpc_connection_id

  depends_on = [module.project_services]
}

module "memorystore" {
  source                    = "../../modules/memorystore"
  project_id                = var.project_id
  region                    = var.region
  vpc_network_id            = module.vpc.network_id
  redis_name                = "qa-redis-cache"
  private_vpc_connection_id = module.vpc.private_vpc_connection_id

  depends_on = [module.project_services]
}

module "secret_manager" {
  source     = "../../modules/secret-manager"
  project_id = var.project_id
  secrets    = ["DATABASE_URL", "REDIS_HOST", "REDIS_PORT", "REDIS_URL", "JWT_SECRET"]
  secret_values = {
    "DATABASE_URL" = module.cloud_sql.database_url
    "REDIS_HOST"   = module.memorystore.host
    "REDIS_PORT"   = module.memorystore.port
    "REDIS_URL"    = module.memorystore.redis_url
    "JWT_SECRET"   = "placeholder-jwt-secret-replace-me"
  }

  depends_on = [module.project_services]
}

module "artifact_registry" {
  source       = "../../modules/artifact-registry"
  project_id   = var.project_id
  region       = var.region
  repositories = ["backend-repo", "frontend-repo"]

  depends_on = [module.project_services]
}

module "cloud_run_backend" {
  source                = "../../modules/cloud-run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "qa-backend-service"
  image_url             = "us-docker.pkg.dev/cloudrun/container/hello"
  container_port        = 8000
  service_account_email = module.service_accounts.emails["backend-sa"]
  min_instances         = 0
  max_instances         = 3
  vpc_connector_id      = module.vpc_connector.connector_id

  secret_env_vars = {
    "DATABASE_URL" = { secret_id = module.secret_manager.secret_ids["DATABASE_URL"] }
    "REDIS_HOST"   = { secret_id = module.secret_manager.secret_ids["REDIS_HOST"] }
    "REDIS_PORT"   = { secret_id = module.secret_manager.secret_ids["REDIS_PORT"] }
    "REDIS_URL"    = { secret_id = module.secret_manager.secret_ids["REDIS_URL"] }
    "JWT_SECRET"   = { secret_id = module.secret_manager.secret_ids["JWT_SECRET"] }
  }

  depends_on = [module.project_services, module.iam]
}

module "cloud_run_frontend" {
  source                = "../../modules/cloud-run"
  project_id            = var.project_id
  region                = var.region
  service_name          = "qa-frontend-service"
  image_url             = "us-docker.pkg.dev/cloudrun/container/hello"
  container_port        = 8080
  service_account_email = module.service_accounts.emails["frontend-sa"]
  min_instances         = 0
  max_instances         = 3

  depends_on = [module.project_services, module.iam]
}

module "ssl" {
  source     = "../../modules/ssl"
  project_id = var.project_id
  cert_name  = "qa-managed-cert"
  domain     = var.domain

  depends_on = [module.project_services]
}

module "load_balancer" {
  source             = "../../modules/load-balancer"
  project_id         = var.project_id
  lb_name            = "qa-lb"
  domain             = var.domain
  backend_neg_id     = module.cloud_run_backend.neg_id
  frontend_neg_id    = module.cloud_run_frontend.neg_id
  ssl_certificate_id = module.ssl.certificate_id

  depends_on = [module.project_services]
}
