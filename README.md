# The Forge project infrastructure

Terraform infrastructure to provision a **GKE (Google Kubernetes Engine)** cluster on GCP.

## Prerequisites

* Scoop (Windows) or Homebrew (MacOS) to install Terraform
* Python and pip to install pre-commit hooks and Checkov

## Architecture

```
Dedicated VPC ──▶ Subnet (10.10.0.0/24) ──▶ GKE Cluster (managed node pool)
```

Simple, single-region architecture, suited for a POC.

## Repository structure

| File | Role |
|---|---|
| `vpc.tf` | Declares the **VPC** and a **subnet** to isolate the cluster, along with the `project_id` / `region` variables and the Google provider. |
| `gke.tf` | Creates the **GKE cluster** (version 1.27.x, default node pool removed) and a **separate node pool** of 2 `n1-standard-1` nodes. |
| `versions.tf` | Pins the Google provider to version `7.33.0` and Terraform `>= 0.14`. |
| `outputs.tf` | Exposes the region, project ID, cluster name, and endpoint. |
| `terraform.tfvars` | Input variables (`project_id` to be replaced). |

## Usage

1. Install dependencies:
   ```bash
   make install
   ```
2. Initialize the repo and pre-commit hooks:
   ```bash
   make init
   ```
3. Validate the Terraform configuration:
   ```bash
   make validate
   ```
4. Apply configuration:
   ```bash
   make plan
   make apply
   ```