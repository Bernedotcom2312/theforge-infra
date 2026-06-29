# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Infrastructure-as-code for **The Forge** POC — provisions a GKE cluster on GCP (europe-west1) with ArgoCD for GitOps-based continuous deployment. The companion CD repo (`github.com/Bernedotcom2312/theforge-cd`) holds the application manifests that ArgoCD watches.

## Common Commands

All local development goes through `make`:

```bash
make install    # Install Terraform (Scoop/Windows), pre-commit hooks, Checkov
make init       # terraform init + install pre-commit hooks
make validate   # terraform init + terraform validate
make fmt        # Format all .tf files
make plan       # Generate and display execution plan
make apply      # Apply changes to GCP
make destroy    # Tear down all resources
make output     # Print cluster name, endpoint, region, project_id
make clean      # Remove .terraform/, lock files, state backups
```

Pre-commit hooks run automatically on `git commit`: `terraform_fmt`, `terraform_validate`, `terraform_tflint`, `terraform_checkov`.

## Conventional commits

This repo uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages. Example:

```
feat: add GKE cluster with ArgoCD
```

## IAM & Security

* Least privilege principle is followed, service account used by Terraform should only have the permissions needed, avoid owner / editor roles.
* IAM binding are explicitly managed by Terraform, avoid manual changes in GCP console.
* Each service account has a unique email address, avoid sharing service accounts between different components and should be described in the codebase.

## Architecture

### Infrastructure Stack

- **Terraform ≥1.15.6** — single flat module, no subdirectory modules
- **GCP project:** `deft-accord-496812-k9`, region `europe-west1`
- **Remote state:** GCS bucket `theforge-infra-tfstate-deft-accord-496812-k9` (prefix `terraform/state`)
- **Provider versions locked in `.terraform.lock.hcl`:** google 7.33.0, helm 3.1.2, kubernetes 3.1.0, kubectl 1.34.1

### Resource Topology

```
VPC (10.10.0.0/24)
  └── GKE Cluster (managed master, 2× n1-standard-1 nodes)
        └── ArgoCD namespace (Helm chart v9.5.15, --insecure mode)
              └── Root ArgoCD Application → theforge-cd repo (main branch)
```

Key design choices:
- **Default node pool is deleted** — only the explicitly managed pool runs.
- ArgoCD is deployed with Dex, notifications, and ApplicationSet disabled (minimalist POC setup).
- ArgoCD server runs in `--insecure` mode (no TLS termination at the pod level).

### Provider Authentication Flow

`providers.tf` reads a GCP access token from `data.google_client_config` and passes it directly to the `kubernetes`, `helm`, and `kubectl` providers. This means Terraform itself handles cluster auth — no separate `kubeconfig` step needed during `terraform apply`.

### CI/CD Pipelines

**CI** (`.github/workflows/terraform-ci.yml`, triggers on PRs):
`fmt-check → init → validate → tflint → checkov → plan` — plan artifact is uploaded for the CD step.

**CD** (`.github/workflows/terraform-cd.yml`, triggers on push to main):
Downloads the plan artifact from the matching CI run, then runs `terraform apply -auto-approve`.

Both pipelines authenticate to GCP via **Workload Identity Federation** (keyless — no service account key stored in GitHub secrets). The reusable setup logic lives in `.github/actions/terraform-setup/action.yml`.

## Forbiden actions

* Each change must be commited on a dedicated branch and merged via PR, no direct push to main
* Never store secrets in code base
* Reuse existing modules instead of duplicating logic
* Avoid wildcard versions