# Disaster Recovery Guide

## Cloud SQL
- Automated backups are enabled.
- Point-in-time recovery (PITR) is enabled.
- To restore: Use the GCP Console or `gcloud` to restore to a specific timestamp.

## Redis
- Basic tier is used. Since cache is ephemeral, in a disaster scenario the instance will be recreated empty.

## Terraform State
- The GCS backend bucket has versioning enabled.
- If the state file gets corrupted, you can restore a previous version from the bucket.
