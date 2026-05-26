# theforge-infra

Infrastructure Terraform pour provisionner un cluster **GKE (Google Kubernetes Engine)** sur GCP.

## Architecture

```
VPC dédié ──▶ Subnet (10.10.0.0/24) ──▶ Cluster GKE (node pool managé)
```

Architecture simple, single-region, adaptée à un POC.

## Structure du repo

| Fichier | Rôle |
|---|---|
| `vpc.tf` | Déclare le **VPC** et un **subnet** pour isoler le cluster, ainsi que les variables `project_id` / `region` et le provider Google. |
| `gke.tf` | Crée le **cluster GKE** (version 1.27.x, default node pool supprimé) et un **node pool séparé** de 2 nœuds `n1-standard-1`. |
| `versions.tf` | Fixe le provider Google à la version `7.33.0` et Terraform `>= 0.14`. |
| `outputs.tf` | Expose la région, le project ID, le nom et l'endpoint du cluster. |
| `terraform.tfvars` | Variables d'entrée (`project_id` à remplacer, région `us-central1`). |
| `kubernetes-dashboard-admin.rbac.yaml` | Manifest RBAC Kubernetes pour un accès admin au dashboard (à appliquer post-déploiement). |

## Utilisation

1. Renseigner le `project_id` dans `terraform.tfvars`.
2. Lancer le déploiement :
   ```bash
   terraform init
   terraform apply
   ```
3. Configurer `kubectl` :
   ```bash
   gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
   ```
4. (Optionnel) Appliquer le RBAC pour le dashboard :
   ```bash
   kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
   ```
